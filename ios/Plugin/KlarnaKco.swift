import Foundation
import Capacitor
import KlarnaCheckoutSDK
import os
import UIKit

class KlarnaKco: NSObject {
    private let config: KlarnaKcoConfig
    private let bridge: CAPBridgeProtocol
    private let plugin: KlarnaKcoPlugin
    public var checkout: KCOKlarnaCheckout?
    
    init(plugin: KlarnaKcoPlugin, config: KlarnaKcoConfig) {
        self.plugin = plugin
        self.config = config
        self.bridge = self.plugin.bridge!

        super.init()
        initialize()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func destroyKlarna() {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.KCOSignal, object: nil)
        self.checkout?.destroy()
        self.checkout = nil
    }
    
    @objc func initialize() {
        let checkout = self.initKlarnaHybridSdk(self.bridge.viewController!, config: self.config, webView: self.bridge.webView)
        self.checkout = checkout
        self.checkout?.notifyViewDidLoad()
    }
    
    @objc func notifyWeb(key: String, data: [String : Any]?) -> Void {
        self.plugin.notifyListeners(key, data: data ?? [:])
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
                self.notifyWeb(key: "complete", data: [
                    "url": url.absoluteString,
                    "path" : url.path
                ])
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
        klarnaCheckout.setWebView(webView)
        klarnaCheckout.notifyViewDidLoad()

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleNotification),
            name: NSNotification.Name.KCOSignal,
            object: nil
        )

        return klarnaCheckout
    }
}
