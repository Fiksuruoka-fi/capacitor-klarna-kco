import Foundation
import Capacitor
import KlarnaMobileSDK
import KlarnaCheckoutSDK
import os

class KlarnaKco: NSObject {
    private let plugin: KlarnaKcoPlugin
    private let config: KlarnaKcoConfig
    private let bridge: CAPBridgeProtocol
    private var sdk: KlarnaHybridSDK?
    private var checkout: KCOKlarnaCheckout?
    
    init(plugin: KlarnaKcoPlugin, config: KlarnaKcoConfig) {
        self.plugin = plugin
        self.config = config
        self.bridge = self.plugin.bridge!
        super.init()
        self.initKlarnaHybridSdk(config: self.config)
    }
    
    @objc func deviceIdentifier() -> String {
        return KlarnaMobileSDKCommon.deviceIdentifier()
    }
    
    @objc func notifyWeb(key: String, data: [String : Any]?) -> Void {
        self.plugin.notifyListeners(key, data: data ?? [:])
    }
    
    @objc func loaded() {
        print("[Klarna Chekout] Try to notify Checkout SDK")
        self.checkout?.notifyViewDidLoad()
    }
    
    @objc func destroy() {
        self.checkout?.destroy()
    }
    
    @objc func handleNotification(_ notification: Notification?) {
        let name = notification?.userInfo?[KCOSignalNameKey] as? String ?? ""
        let data = notification?.userInfo?[KCOSignalDataKey] as? [AnyHashable : Any] ?? [:]
        self.notifyWeb(key: name, data: [:])
        if name == "complete" {
            handleCompletionUri(data["uri"] as? String)
        }
    }
    
    func initKlarnaHybridSdk(config: KlarnaKcoConfig) {
        if let klarnaCheckout = KCOKlarnaCheckout(
            viewController: self.bridge.viewController!,
            return: self.config.iosReturnUrl) {
            klarnaCheckout.setWebView(self.bridge.webView)
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
