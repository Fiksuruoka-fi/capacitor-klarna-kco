import Foundation
import Capacitor
import KlarnaMobileSDK
import KlarnaCheckoutSDK
import os
import UIKit

class KlarnaKco: NSObject {
    private let config: KlarnaKcoConfig
    private let plugin: KlarnaKcoPlugin
    private let bridge: CAPBridgeProtocol
    private var sdk: KlarnaHybridSDK?
    public var browser: BrowserViewController?
    public var checkout: KCOKlarnaCheckout?
    
    init(plugin: KlarnaKcoPlugin, config: KlarnaKcoConfig) {
        self.plugin = plugin
        self.config = config
        self.bridge = self.plugin.bridge!

        super.init()
        
        openBrowser()
    }
    
    func openBrowser() {
        DispatchQueue.main.async {
            self.browser = BrowserViewController(config: self.config, implementation: self)
            self.bridge.viewController?.present(self.browser!, animated: true, completion: nil)
        }
    }
    
    @objc func deviceIdentifier() -> String {
        return KlarnaMobileSDKCommon.deviceIdentifier()
    }
    
    @objc func notifyWeb(key: String, data: [String : Any]?) -> Void {
        self.plugin.notifyListeners(key, data: data ?? [:])
    }
    
    @objc func initialize() {
        self.initKlarnaHybridSdk(self.bridge.viewController!, config: self.config, webView: self.bridge.webView)
    }
    
    @objc func loaded() {
        print("[Klarna Checkout] Try to notify Checkout SDK")
        self.checkout?.notifyViewDidLoad()
    }
    
    @objc func destroyKlarna() {
        print("[Klarna Checkout] Destroy")
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.KCOSignal, object: nil)
        self.browser?.dismiss(animated: true)
        self.browser = nil
        self.checkout?.destroy()
    }
    
    @objc func handleNotification(_ notification: Notification?) {
        let name = notification?.userInfo?[KCOSignalNameKey] as? String ?? ""
        let data = notification?.userInfo?[KCOSignalDataKey] as? [String : Any] ?? [:]
        
        print("[Klarna Checkout] Notification \(name.description), \(data.description)")

        if name == "complete" {
            handleCompletionUri(data["uri"] as? String)
        } else {
            self.notifyWeb(key: name, data: data)
        }
    }
    
    func initKlarnaHybridSdk(_ viewController: UIViewController, config: KlarnaKcoConfig, webView: WKWebView?) -> KCOKlarnaCheckout {
        let klarnaCheckout: KCOKlarnaCheckout = KCOKlarnaCheckout(
            viewController: viewController,
            return: self.config.iosReturnUrl)

        klarnaCheckout.merchantHandlesValidationErrors = self.config.handleValidationErrors

        if (config.snippet.isEmpty) {
            klarnaCheckout.setWebView(webView)
        } else {
            klarnaCheckout.setSnippet(config.snippet)
        }
         
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification),
            name: NSNotification.Name.KCOSignal,
            object: nil
        )

        self.checkout = klarnaCheckout
        print("[Klarna Checkout] Checkout SDK initialized")

        return klarnaCheckout
    }
    
    func handleCompletionUri(_ uri: String?) {
        if uri != nil && (uri != nil) && (uri?.count ?? 0) > 0 {
            let url = URL(string: uri ?? "")
            if let url = url {
                if (self.config.handleConfirmation) {
                    let request = NSMutableURLRequest(url: url as URL)
                    request.setValue("cd91f76501174205a2e62038473380c8.access", forHTTPHeaderField: "CF-Access-Client-Id")
                    request.setValue("8bbd2d8e06cec796c62ef1d2689ef9edd6fac318aac75e9ba5da20ea36724960", forHTTPHeaderField: "CF-Access-Client-Secret")
                    request.httpMethod = "GET"
                    
                    let task = URLSession.shared.dataTask(with: request as URLRequest) { data, response, error in
                        if let response = response {
                            print("HTTP Response \(response.debugDescription)")
                        }
                        else if let error = error {
                            print("HTTP Request Failed \(error)")
                        }
                    }
                    task.resume()
                }
                
                self.notifyWeb(key: "complete", data: [
                    "url": url.absoluteString,
                    "path" : url.path
                ])
                
                self.browser?.dismiss(animated: true)

                return
            }
        }
        
    }
}
