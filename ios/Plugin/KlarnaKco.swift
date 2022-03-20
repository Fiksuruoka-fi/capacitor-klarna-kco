import Foundation
import Capacitor
import KlarnaMobileSDK
import KlarnaCheckoutSDK
import os

class KlarnaKco: NSObject {
    @IBOutlet weak var webView: WKWebView!
    
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
        
        self.initKlarnaHybridSdk(config: config)
    }
    
    @objc func deviceIdentifier() -> String {
        return KlarnaMobileSDKCommon.deviceIdentifier()
    }
    
    @objc func notifyWeb(key: String, data: [String : Any]?) -> Void {
        self.plugin.notifyListeners(key, data: data ?? [:])
    }
    
    @objc func viewDidLoad() {
        self.checkout?.notifyViewDidLoad()
    }
    
    private func handle(_ notification: Notification?) {
        let name = notification?.userInfo?[KCOSignalNameKey] as? String ?? ""
        let data = notification?.userInfo?[KCOSignalDataKey] as? [AnyHashable : Any] ?? [:]
        
        print("[Klarna Checkout] Receive notification \(name), \(data.description)")
        
        if name == "complete" {
            handleCompletionUri(data["uri"] as? String)
        }
    }
    
    private func handleCompletionUri(_ uri: String?) {
        if uri != nil && (uri != nil) && (uri?.count ?? 0) > 0 {
            let url = URL(string: uri ?? "")
            if let url = url {
                print("[Klarna Checkout] Completion URL: \(url)")
                self.bridge.webView?.load(URLRequest(url: url))
            }
        }
    }
    
    private func initKlarnaHybridSdk(config: KlarnaKcoConfig) {
        self.checkout = KCOKlarnaCheckout(viewController: self.bridge.viewController!, return: self.config.iosReturnUrl)
        self.checkout?.setWebView(self.bridge.webView)
    }
}
