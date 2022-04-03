import Foundation
import Capacitor
import KlarnaCheckoutSDK
import os
import UIKit

class KlarnaKco: NSObject {
    private let config: KlarnaKcoConfig
    private let bridge: CAPBridgeProtocol
    private let plugin: KlarnaKcoPlugin
    public var browser: BrowserViewController?
    public var checkout: KCOKlarnaCheckout?
    
    init(plugin: KlarnaKcoPlugin, config: KlarnaKcoConfig) {
        self.plugin = plugin
        self.config = config
        self.bridge = self.plugin.bridge!

        super.init()
        
        if (self.config.checkoutUrl.isEmpty && self.config.snippet.isEmpty) {
           initialize()
        } else {
            openBrowser()
        }
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default))
            
        let vc = self.browser ?? self.bridge.viewController
        vc?.present(alert, animated: true, completion: nil)
    }
    
    @objc func destroyKlarna() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.KCOSignal, object: nil)
        self.browser?.dismiss(animated: true)
        self.browser = nil
        self.checkout?.destroy()
        self.checkout = nil
    }
    
    @objc func initialize() {
        self.initKlarnaHybridSdk(self.bridge.viewController!, config: self.config, webView: self.bridge.webView)
    }
    
    @objc func loaded() {
        self.checkout?.notifyViewDidLoad()
    }
    
    @objc func notifyWeb(key: String, data: [String : Any]?) -> Void {
        self.plugin.notifyListeners(key, data: data ?? [:])
    }
    
    func openBrowser() {
        self.browser = BrowserViewController(config: self.config, implementation: self)
        self.bridge.viewController?.present(self.browser!, animated: true, completion: nil)
    }
    
    @objc func resume() {
        self.checkout?.resume()
    }
    
    @objc func suspend() {
        self.checkout?.suspend()
    }
}

/**
 * Handle Klarna notifications
 */
extension KlarnaKco {
    @objc func handleNotification(_ notification: Notification?) {
        let name = notification?.userInfo?[KCOSignalNameKey] as? String ?? ""
        let data = notification?.userInfo?[KCOSignalDataKey] as? [String : Any] ?? [:]
        if name == "complete" {
            handleCompletionUri(data["uri"] as? String)
        } else {
            self.notifyWeb(key: name, data: data)
        }
    }

    func handleCompletionUri(_ uri: String?) {
        if uri != nil && (uri != nil) && (uri?.count ?? 0) > 0 {
            let url = URL(string: uri ?? "")
            if let url = url {
                if (self.config.handleConfirmation) {
                    let request = NSMutableURLRequest(url: url as URL)
                    request.httpMethod = "GET"
                    let task = URLSession.shared.dataTask(with: request as URLRequest)
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

/**
 * Setup Klarna SDK
 */
extension KlarnaKco {
    func initKlarnaHybridSdk(_ viewController: UIViewController, config: KlarnaKcoConfig, webView: WKWebView?) -> KCOKlarnaCheckout {
        let klarnaCheckout: KCOKlarnaCheckout = KCOKlarnaCheckout(
            viewController: viewController,
            return: self.config.iosReturnUrl)
        klarnaCheckout.merchantHandlesValidationErrors = self.config.handleValidationErrors
        if (config.snippet.isEmpty) {
            klarnaCheckout.setWebView(webView)
            klarnaCheckout.notifyViewDidLoad()
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
        return klarnaCheckout
    }
}
