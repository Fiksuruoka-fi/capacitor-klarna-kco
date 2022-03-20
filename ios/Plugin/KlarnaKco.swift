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
    
    @objc func setSnippet(snippet: String) {
        self.checkout?.setSnippet(snippet)
    }
    
    private func initKlarnaHybridSdk(config: KlarnaKcoConfig) {
        self.checkout = KCOKlarnaCheckout.init(viewController: self.bridge.viewController!, return: URL(string: URL))
        self.checkout.
        
        
//        self.sdk = KlarnaHybridSDK(returnUrl: URL(string: URL)!, klarnaEventListener: self)
        
//        (returnUrl: config.iosReturnUrl!, eventListener: self)
//        self.sdk?.addWebView(self.bridge.webView!)
    }
}

extension KlarnaKco: WKNavigationDelegate {
    @objc func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        self.sdk?.newPageLoad(in: self.bridge.webView!)
    }

    @objc func webView(_ webView: WKWebView,
                 decidePolicyFor navigationAction: WKNavigationAction,
                 decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let shouldFollow = self.sdk?.shouldFollowNavigation(withRequest: navigationAction.request)
        decisionHandler(shouldFollow! ? WKNavigationActionPolicy.allow : WKNavigationActionPolicy.cancel)
    }
}

extension KlarnaKco: KlarnaFullscreenEventListener, KlarnaEventListener {
    func klarnaComponent(_ view: KlarnaComponent, didReceiveEvent event: String, params: [String : Any]) {
        print("[KlarnaHybridSDK]: did recieve event: \(params.description)")
        self.notifyWeb(key: event, data: params)
    }

    func klarnaComponent(_ view: KlarnaComponent, didReceiveError error: KlarnaMobileSDKError) {
        print("[KlarnaHybridSDK]: did recieve error: \(error.debugDescription)")
        self.notifyWeb(key: KlarnaEvents.Failed.rawValue, data: ["message": error.message])
    }
    
    
    @objc func klarnaFailed(inWebView webView: KlarnaWebView, withError error: KlarnaMobileSDKError) {
        self.notifyWeb(key: KlarnaEvents.Failed.rawValue, data: ["message": error.message])
    }
    
    @objc func klarnaWillShowFullscreen(inWebView webView: KlarnaWebView, completionHandler: @escaping () -> Void) {
        self.notifyWeb(key: KlarnaEvents.WillShow.rawValue, data: [:])
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
}
