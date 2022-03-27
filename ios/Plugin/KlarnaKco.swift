import Foundation
import Capacitor
import KlarnaMobileSDK
import KlarnaCheckoutSDK
import os
import UIKit

class KlarnaKco: NSObject {
    private let plugin: KlarnaKcoPlugin
    private let config: KlarnaKcoConfig
    private let bridge: CAPBridgeProtocol
    private var browser: UIViewController?
    private var sdk: KlarnaHybridSDK?
    private var checkout: KCOKlarnaCheckout?
    
    init(plugin: KlarnaKcoPlugin, config: KlarnaKcoConfig, snippet: String?) {
        self.plugin = plugin
        self.config = config
        self.bridge = self.plugin.bridge!
        super.init()
        
        if (snippet == nil) {
            initKlarnaHybridSdk(config: self.config, snippet: snippet, webView: nil)
        }
        
        openBrowser(useSnippet: snippet != nil)
    }
    
    func openBrowser(useSnippet: Bool) {
        if (useSnippet) {
            self.browser = self.checkout?.checkoutViewController
        } else {
            self.browser = BrowserViewController()
        }
        DispatchQueue.main.async {
            self.bridge.viewController?.present(self.browser!, animated: true, completion: nil)
        }
    }
    
    @objc func deviceIdentifier() -> String {
        return KlarnaMobileSDKCommon.deviceIdentifier()
    }
    
    @objc func notifyWeb(key: String, data: [String : Any]?) -> Void {
        self.plugin.notifyListeners(key, data: data ?? [:])
    }
    
    @objc func loaded() {
        print("[Klarna Checkout] Try to notify Checkout SDK")
        self.checkout?.notifyViewDidLoad()
    }
    
    @objc func destroy() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.KCOSignal, object: nil)
        self.checkout?.destroy()
        self.browser?.dismiss(animated: true)
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
    
    func initKlarnaHybridSdk(config: KlarnaKcoConfig, snippet: String?, webView: WKWebView?) {
        if let klarnaCheckout = KCOKlarnaCheckout(
            viewController: self.browser,
            return: self.config.iosReturnUrl) {
            klarnaCheckout.merchantHandlesValidationErrors = self.config.handleValidationErrors

            if ((snippet == nil)) {
                klarnaCheckout.setWebView(webView)
            } else {
                klarnaCheckout.setSnippet(snippet)
            }

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(handleNotification),
                name: NSNotification.Name.KCOSignal,
                object: nil
            )

            self.checkout = klarnaCheckout
            print("[Klarna Checkout] Checkout SDK initialized")
        }
    }
    
    func handleCompletionUri(_ uri: String?) {
        if uri != nil && (uri != nil) && (uri?.count ?? 0) > 0 {
            let url = URL(string: uri ?? "")
            if let url = url {
                self.notifyWeb(key: "complete", data: [
                    "url": url.absoluteString,
                    "path" : url.path
                ])
                return
            }
        }
    }
}
