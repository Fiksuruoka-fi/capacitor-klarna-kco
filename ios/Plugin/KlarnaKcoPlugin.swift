import Foundation
import Capacitor
import KlarnaMobileSDK
import NotificationBannerSwift

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
        guard let implementation = self.implementation else {
            call.reject("Klarna plugin not initialized")
            return
        }

        let result = implementation.setSnippet(snippet: call.getString("snippet", ""))
        if result.status {
            call.resolve(["status": result.status, "message": result.message])
        } else {
            call.reject(result.message)
        }
    }
    
    @objc
    func open(_ call: CAPPluginCall) {
        guard let implementation = self.implementation else {
            call.reject("Klarna plugin not initialized")
            return
        }
        
        let result = implementation.open()
        if result.status {
            call.resolve(["status": result.status, "message": result.message])
            return
        } else {
            call.reject(result.message)
        }
    }
    
    @objc
    func close(_ call: CAPPluginCall) {
        guard let implementation = self.implementation else {
            call.reject("Klarna plugin not initialized")
            return
        }
        
        let result = implementation.close()
        if result.status {
            call.resolve(["status": result.status, "message": result.message])
        } else {
            call.reject(result.message)
        }
    }
    
    @objc
    func resume(_ call: CAPPluginCall) {
        guard let implementation = self.implementation else {
            call.reject("Klarna plugin not initialized")
            return
        }

        implementation.resume()
        call.resolve(["result": "invoked"])
    }
    
    @objc
    func suspend(_ call: CAPPluginCall) {
        guard let implementation = self.implementation else {
            call.reject("Klarna plugin not initialized")
            return
        }

        implementation.suspend()
        call.resolve(["result": "invoked"])
    }
    
    @objc
    func destroy(_ call: CAPPluginCall) {
        guard let implementation = self.implementation else {
            call.reject("Klarna plugin not initialized")
            return
        }

        implementation.destroy()
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
            break
        }
        
        switch getConfig().getString("theme", "") {
        case "light":
            config.theme = KlarnaTheme.light
            break
        case "dark":
            config.theme = KlarnaTheme.dark
            break
        case "automatic":
            config.theme = KlarnaTheme.automatic
            break
        default:
            break
        }
    }
}

extension UIColor {
    public convenience init?(hexString: String) {
        let r, g, b, a: CGFloat
        
        if hexString.hasPrefix("#") {
            let start = hexString.index(hexString.startIndex, offsetBy: 1)
            var hexColor = String(hexString[start...])
            if (hexColor.count == 6) {
                hexColor = "\(hexColor)ff"
            }
            let scanner = Scanner(string: hexColor)
            var hexNumber: UInt64 = 0
            
            if scanner.scanHexInt64(&hexNumber) {
                r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                a = CGFloat(hexNumber & 0x000000ff) / 255
                
                self.init(red: r, green: g, blue: b, alpha: a)
                return
            }
        }
        
        return nil
    }
}

