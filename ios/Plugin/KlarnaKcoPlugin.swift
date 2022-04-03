import Foundation
import Capacitor
import KlarnaMobileSDK

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(KlarnaKcoPlugin)
public class KlarnaKcoPlugin: CAPPlugin {
    private var implementation: KlarnaKco?
    private var config: KlarnaKcoConfig?
    
    @objc func alert(_ call: CAPPluginCall) {
        let title = call.getString("title") ?? ""
        let message = call.getString("message") ?? ""

        DispatchQueue.main.async {
            self.implementation?.alert(title: title, message: message)
            call.resolve()
        }
    }
    
    @objc func destroy(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.implementation?.destroyKlarna()
            call.resolve()
        }
    }
    
    @objc func initialize(_ call: CAPPluginCall) {
        let snippet = call.getString("snippet") ?? ""
        let checkoutUrl = call.getString("checkoutUrl") ?? ""
        
        self.config = self.klarnaKcoConfig(checkoutUrl: checkoutUrl, snippet: snippet)
        
        // Check if KCO is already opened in seperate browser window
        if (self.implementation?.browser?.isLoaded != nil) {
            // Check if snippet was used and set it again
            if (!snippet.isEmpty) {
                DispatchQueue.main.async {
                    self.implementation?.checkout?.setSnippet(snippet)
                    call.resolve()
                }
            }

            // Otherwise set webview to SDK again
            else {
                DispatchQueue.main.async {
                    self.implementation?.checkout?.setWebView(self.implementation?.browser?.webView)
                    call.resolve()
                }
            }
        }

        // Otherwise check if KCO sdk is already initialized and use current viewController and set webview to SDK again
        else if (self.implementation?.checkout != nil) {
            DispatchQueue.main.async {
                self.implementation?.checkout?.setWebView(self.implementation?.browser?.webView)
                call.resolve()
            }
        }

        // Otherwise initialize KCO SDK
        else {
            DispatchQueue.main.async {
                self.implementation = KlarnaKco(plugin: self, config: self.config!)
                call.resolve()
            }
        }
    }
    
    @objc func loaded(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.implementation?.loaded()
            call.resolve()
        }
    }
    
    @objc func resume(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.implementation?.resume()
            call.resolve()
        }
    }
    
    @objc func suspend(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.implementation?.suspend()
            call.resolve()
        }
    }
}

extension KlarnaKcoPlugin {
    private func klarnaKcoConfig(checkoutUrl: String, snippet: String) -> KlarnaKcoConfig {
        var config = KlarnaKcoConfig()
        
        config.checkoutUrl = checkoutUrl
        config.snippet = snippet

        if let iosReturnUrl = URL(string: getConfigValue("iosReturnUrl") as! String) {
            config.iosReturnUrl = iosReturnUrl
        }
        
        if let handleConfirmation = getConfigValue("handleConfirmation") as? Bool {
            config.handleConfirmation = handleConfirmation
        }
        
        if let handleValidationErrors = getConfigValue("handleValidationErrors") as? Bool {
            config.handleValidationErrors = handleValidationErrors
        }
        
        if let title = getConfigValue("title") as? String {
            config.title = title
        }
        
        if let barColor = getConfigValue("barColor") as? String {
            config.barColor = UIColor.capacitor.color(fromHex: barColor) ?? config.barColor
        }
        
        if let barItemColor = getConfigValue("barItemColor") as? String {
            config.barItemColor = UIColor.capacitor.color(fromHex: barItemColor) ?? config.barItemColor
        }
        
        if let cancelText = getConfigValue("cancelText") as? String {
            config.cancelText = cancelText
        }
    
        return config
    }
}
