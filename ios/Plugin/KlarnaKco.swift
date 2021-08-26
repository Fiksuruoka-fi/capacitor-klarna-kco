import Foundation
import Capacitor
import KlarnaMobileSDK

class KlarnaKco: NSObject {
    @IBOutlet weak var webView: WKWebView! {
        didSet {
            webView.navigationDelegate = self
        }
    }
    
    private let plugin: KlarnaKcoPlugin
    private let config: KlarnaKcoConfig
    private let bridge: CAPBridgeProtocol
    private var sdk: KlarnaHybridSDK?
    
    init(plugin: KlarnaKcoPlugin, config: KlarnaKcoConfig) {
        self.plugin = plugin
        self.config = config
        self.bridge = self.plugin.bridge!
        super.init()
        
        self.initKlarnaHybridSdk(config: config)
        self.sdk?.addWebView(webView)
    }
    
    @objc func deviceIdentifier() -> String {
        return KlarnaMobileSDKCommon.deviceIdentifier()
    }
    
    @objc func notifyWeb(key: String, data: [String : Any]?) -> Void {
        self.plugin.notifyListeners(key, data: data ?? [:])
    }
    
    private func initKlarnaHybridSdk(config: KlarnaKcoConfig) {
        self.sdk = KlarnaHybridSDK(returnUrl: config.iosReturnUrl!, eventListener: self)
    }
}

extension KlarnaKco: WKNavigationDelegate {

    @objc func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.sdk?.newPageLoad(in: webView)
    }

    @objc func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {

        decisionHandler(self.sdk?.shouldFollowNavigation(withRequest: navigationAction.request) == true ? .allow : .cancel)
    }
}

extension KlarnaKco: KlarnaHybridEventListener {
    @objc func klarnaWillShowFullscreen(inWebView webView: KlarnaWebView, completionHandler: @escaping () -> Void) {
        self.notifyWeb(key: KlarnaEvents.WillShow.rawValue, data: nil)
        completionHandler()
    }
    
    @objc func klarnaDidShowFullscreen(inWebView webView: KlarnaWebView, completionHandler: @escaping () -> Void) {
        self.notifyWeb(key: KlarnaEvents.DidShow.rawValue, data: nil)
        completionHandler()
    }
    
    @objc func klarnaWillHideFullscreen(inWebView webView: KlarnaWebView, completionHandler: @escaping () -> Void) {
        self.notifyWeb(key: KlarnaEvents.WillHide.rawValue, data: nil)
        completionHandler()
    }
    
    @objc func klarnaDidHideFullscreen(inWebView webView: KlarnaWebView, completionHandler: @escaping () -> Void) {
        self.notifyWeb(key: KlarnaEvents.DidHide.rawValue, data: nil)
        completionHandler()
    }
    
    @objc func klarnaFailed(inWebView webView: KlarnaWebView, withError error: KlarnaMobileSDKError) {
        self.notifyWeb(key: KlarnaEvents.Failed.rawValue, data: ["message": error.message])
    }
}
