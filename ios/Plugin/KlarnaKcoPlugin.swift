import Foundation
import Capacitor

/**
 * Please read the Capacitor iOS Plugin Development Guide
 * here: https://capacitorjs.com/docs/plugins/ios
 */
@objc(KlarnaKcoPlugin)
public class KlarnaKcoPlugin: CAPPlugin {
    private var implementation: KlarnaKco?
    private var config: KlarnaKcoConfig?
    
    override public func load() {
        self.config = self.klarnaKcoConfig()
        DispatchQueue.main.async {
            self.implementation = KlarnaKco(plugin: self, config: self.config!)
        }
    }
    
    @objc func destroy(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.implementation!.destroyKlarna()
            call.resolve()
        }
    }
    
    @objc func resume(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.implementation!.resume()
            call.resolve()
        }
    }
    
    @objc func suspend(_ call: CAPPluginCall) {
        DispatchQueue.main.async {
            self.implementation!.suspend()
            call.resolve()
        }
    }
}

extension KlarnaKcoPlugin {
    private func klarnaKcoConfig() -> KlarnaKcoConfig {
        var config = KlarnaKcoConfig()

        if let iosReturnUrl = URL(string: getConfigValue("iosReturnUrl") as! String) {
            config.iosReturnUrl = iosReturnUrl
        }
        
        if let handleValidationErrors = getConfigValue("handleValidationErrors") as? Bool {
            config.handleValidationErrors = handleValidationErrors
        }

        if let handleEPM = getConfigValue("handleEPM") as? Bool {
            config.handleEPM = handleEPM
        }
    
        return config
    }
}
