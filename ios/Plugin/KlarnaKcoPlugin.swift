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

    override public func load() {
        self.implementation = KlarnaKco(plugin: self, config: klarnaKcoConfig())
    }

    @objc func echo(_ call: CAPPluginCall) {
        let value = call.getString("value") ?? ""
        call.resolve([
            "value": value
        ])
    }
    
    @objc func deviceIdentifier(_ call: CAPPluginCall) {
        let result = implementation?.deviceIdentifier()
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

        if let iosReturnUrl = URL.init(string: getConfigValue("iosReturnUrl") as! String) {
            config.iosReturnUrl = iosReturnUrl
        }
    
        return config
    }
}
