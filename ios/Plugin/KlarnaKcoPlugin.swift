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
    private var config = KlarnaKcoConfig()

    @objc
    func initialize(_ call: CAPPluginCall) {
        self.klarnaKcoConfig()
        self.implementation = KlarnaKco(plugin: self, config: self.config)
    }
    
    @objc
    func setSnippet(_ call: CAPPluginCall) {
        self.implementation?.setSnippet(snippet: call.getString("snippet", ""))
        call.resolve()
    }
    
    @objc
    func open(_ call: CAPPluginCall) {
        self.implementation?.open()
        call.resolve()
    }
    
    @objc
    func close(_ call: CAPPluginCall) {
        self.implementation?.close()
        call.resolve()
    }
    
    @objc
    func expand(_ call: CAPPluginCall) {
        if #available(iOS 15.0, *) {
            self.implementation?.expand()
            call.resolve()
        } else {
            CAPLog.print("Klarna KCO plugin: Expand not supported under iOS version 15.0")
            call.unavailable("Expand not supported under iOS version 15.0")
        }
    }
    
    @objc
    func resume(_ call: CAPPluginCall) {
        self.implementation?.resume()
        call.resolve()
    }
    
    @objc
    func suspend(_ call: CAPPluginCall) {
        self.implementation?.suspend()
        call.resolve()
    }
    
    @objc
    func destroy(_ call: CAPPluginCall) {
        self.implementation?.destroy()
        call.resolve()
    }
}

extension KlarnaKcoPlugin {
    private func klarnaKcoConfig() {
        config.iosReturnUrl = URL(string: getConfig().getString("iosReturnUrl", "")!)
        config.handleValidationErrors = getConfig().getBoolean("handleValidationErrors", false)
        config.handleEPM = getConfig().getBoolean("handleEPM", false)
        
        switch getConfig().getString("region", "") {
        case "eu":
            self.config.region = KlarnaRegion.eu
            break
        case "na":
            config.region = KlarnaRegion.na
            break
        case "oc":
            config.region = KlarnaRegion.oc
            break
        default:
            config.region = KlarnaRegion.eu
            break
        }
        
        switch getConfig().getString("environment", "") {
        case "demo":
            config.environment = KlarnaEnvironment.demo
            break
        case "playground":
            config.environment = KlarnaEnvironment.playground
            break
        case "staging":
            config.environment = KlarnaEnvironment.staging
            break
        case "production":
            config.environment = KlarnaEnvironment.production
            break
        default:
            config.environment = KlarnaEnvironment.playground
            break
        }
        
        switch getConfig().getString("loggingLevel", "") {
        case "verbose":
            config.loggingLevel = KlarnaLoggingLevel.verbose
            break
        case "error":
            config.loggingLevel = KlarnaLoggingLevel.error
            break
        case "off":
            config.loggingLevel = KlarnaLoggingLevel.off
            break
        default:
            config.loggingLevel = KlarnaLoggingLevel.off
            break
        }
    }
}
