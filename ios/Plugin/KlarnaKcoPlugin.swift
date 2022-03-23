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
    
    @objc func initialize(_ call: CAPPluginCall) {
        print("[Klarna Chekout] Initialize")
        DispatchQueue.main.async {
            self.implementation = KlarnaKco(plugin: self, config: self.klarnaKcoConfig())
            call.resolve()
        }
    }
    
    @objc func loaded(_ call: CAPPluginCall) {
        print("[Klarna Chekout] Loaded")
        DispatchQueue.main.async {
            self.implementation?.loaded()
            call.resolve()
        }
    }
    
    @objc func destroy(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.implementation?.destroy()
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
    
    private func klarnaKcoConfig() -> KlarnaKcoConfig {
        var config = KlarnaKcoConfig()

        if let iosReturnUrl = URL(string: getConfigValue("iosReturnUrl") as! String) {
            config.iosReturnUrl = iosReturnUrl
        }
    
        return config
    }
}
