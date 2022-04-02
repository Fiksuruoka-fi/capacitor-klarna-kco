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
    
    @objc func initialize(_ call: CAPPluginCall) {
        print("[Klarna Checkout] Initialize")
        let snippet = call.getString("snippet") ?? ""
        let checkoutUrl = call.getString("checkoutUrl") ?? ""
        
        self.config = self.klarnaKcoConfig(checkoutUrl: checkoutUrl, snippet: snippet)
        
        if (self.implementation?.browser?.isLoaded != nil) {
            self.implementation?.destroyKlarna()
        }
        
        DispatchQueue.main.async {
            self.implementation = KlarnaKco(plugin: self, config: self.config!)
            call.resolve()
        }
    }
    
    @objc func loaded(_ call: CAPPluginCall) {
        print("[Klarna Checkout] Loaded")
        DispatchQueue.main.async {
            self.implementation?.loaded()
            call.resolve()
        }
    }
    
    @objc func destroy(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.implementation?.destroyKlarna()
            call.resolve()
        }
    }
    
    @objc func deviceIdentifier(_ call: CAPPluginCall) {
        let result = self.implementation?.deviceIdentifier()
        call.resolve(["result": result ?? "undefined"])
    }
    
    @objc func setLoggingLevel(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        
        if value.isEmpty {
            KlarnaMobileSDKCommon.setLoggingLevel(getConfigValue("verbose") as! KlarnaLoggingLevel)
        } else {
            KlarnaMobileSDKCommon.setLoggingLevel(getConfigValue(value) as! KlarnaLoggingLevel)
        }

        call.resolve()
        
    }
    
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
