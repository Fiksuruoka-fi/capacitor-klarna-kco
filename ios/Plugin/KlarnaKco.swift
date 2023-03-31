import Foundation
import Capacitor
import os
import UIKit
import KlarnaMobileSDK
import NotificationBannerSwift

class KlarnaKco: NSObject {
    private let config: KlarnaKcoConfig
    private let bridge: CAPBridgeProtocol
    private let plugin: KlarnaKcoPlugin
    private var banner: FloatingNotificationBanner?
    public var opened = false
    public var checkout: KlarnaCheckoutView?
    public var checkoutViewController: KlarnaKcoViewController?
    
    init(plugin: KlarnaKcoPlugin, config: KlarnaKcoConfig) {
        self.plugin = plugin
        self.config = config
        self.bridge = self.plugin.bridge!
        super.init()
        initialize()
    }
    
    @objc
    func initialize() {
        let semaphore = DispatchSemaphore(value: 0)
        DispatchQueue.main.async {
            CAPLog.print("Klarna KCO plugin: Initialize")

            if self.checkoutViewController == nil {
                self.checkoutViewController = KlarnaKcoViewController()
            }

            self.initKlarnaSdk()
            semaphore.signal()
        }
        semaphore.wait()
        return
    }
    
    func setSnippet(snippet: String) -> (status: Bool, message: String){
        var status: Bool = false
        var message: String = ""
        let semaphore = DispatchSemaphore(value: 0)

        DispatchQueue.main.async {
            guard let checkout = self.checkout else {
                message = "Checkout SDK not initialized"
                semaphore.signal()
                return
            }
            
            status = true
            message = "Set snippet on checkout view"
            checkout.setSnippet(snippet)
            semaphore.signal()
        }
        
        semaphore.wait()
        CAPLog.print("Klarna KCO plugin: " + message)
        return (status, message)
    }
    
    func open() -> (status: Bool, message: String){
        var message = ""
        var status = false
        let semaphore = DispatchSemaphore(value: 0)
        
        DispatchQueue.main.async {
            guard let checkoutViewController = self.checkoutViewController else {
                message = "Checkout view is not initialized"
                semaphore.signal()
                return
            }

            guard let bridgeVc = self.bridge.viewController else {
                message = "Bridge view is not initialized"
                semaphore.signal()
                return
            }

            if checkoutViewController.presentingViewController != nil {
                message = "Checkout view is already open"
            } else {
                checkoutViewController.addKcoView(kco: self, kcoView: self.checkout!)
                bridgeVc.present(checkoutViewController, animated: true, completion: nil)
                message = "Opened checkout view"
                status = true
            }
            semaphore.signal()
        }

        semaphore.wait()
        CAPLog.print("Klarna KCO plugin: " + message)
        return (status, message)
    }
    
    func close() -> (status: Bool, message: String){
        var message = ""
        var status = false
        let semaphore = DispatchSemaphore(value: 0)

        DispatchQueue.main.async {
            guard let checkoutViewController = self.checkoutViewController else {
                message = "Checkout view is not initialized"
                semaphore.signal()
                return
            }
            
            if checkoutViewController.presentingViewController != nil {
                checkoutViewController.dismiss(animated: true)
                status = true
                message = "Closed checkout view"
            } else {
                message = "Checkout view is not open"
            }
            semaphore.signal()
        }
        
        semaphore.wait()
        CAPLog.print("Klarna KCO plugin: " + message)
        return (status, message)
    }
    
    func resume() {
        CAPLog.print("Klarna KCO plugin: Resume widget")
        self.checkout?.resume()
    }
    
    func suspend() {
        CAPLog.print("Klarna KCO plugin: Suspend widget")
        self.checkout?.suspend()
    }
    
    func destroy() {
        DispatchQueue.main.async {
            if let banner = self.banner {
                let numberOfBanners = banner.bannerQueue.numberOfBanners
                CAPLog.print("Klarna KCO plugin: Dismiss " + numberOfBanners.description + " banner(s)")
                (0..<numberOfBanners).forEach { _ in
                    self.dismissBanner()
                }
                self.banner = nil
            }
            
            CAPLog.print("Klarna KCO plugin: Close checkout view")
            self.checkoutViewController?.dismiss(animated: true)

            CAPLog.print("Klarna KCO plugin: Destroy checkout")
            self.checkoutViewController?.destroy()
            self.checkoutViewController = nil

            self.checkout?.removeFromSuperview()
            self.checkout = nil
        }
    }
    
    func notifyWeb(key: String, data: [String : Any]?) -> Void {
        self.plugin.notifyListeners(key, data: data ?? [:])
    }
}

// Klarna Event handler
extension KlarnaKco: KlarnaEventHandler {
    func handleCompletionUri(_ uri: String?) {
        if uri != nil && (uri != nil) && (uri?.count ?? 0) > 0 {
            let url = URL(string: uri ?? "")
            if let url = url {
                self.notifyWeb(key: "complete", data: [
                    "url": url.absoluteString,
                    "path" : url.path
                ])
            }
        }
    }
    
    func handleEPM(_ uri: String?) {
        if uri != nil && (uri != nil) && (uri?.count ?? 0) > 0 {
            let url = URL(string: uri ?? "")
            if let url = url {
                self.notifyWeb(key: "external", data: [
                    "url": url.absoluteString,
                    "path" : url.path
                ])
            }
        }
    }

    func klarnaComponent(_ klarnaComponent: KlarnaComponent, dispatchedEvent event: KlarnaProductEvent) {
        CAPLog.print("Klarna KCO plugin event: " + event.action.description + ", " + event.params.description)

        if event.action == "complete" {
            self.handleCompletionUri(event.params["uri"] as? String)
        } else if event.action == "external" {
            self.handleEPM(event.params["uri"] as? String)
        } else {
            self.notifyWeb(key: event.action, data: event.params)
        }
    }
     
    func klarnaComponent(_ klarnaComponent: KlarnaComponent, encounteredError error: KlarnaError) {
        let errorParams = error.dictionaryWithValues(forKeys: ["name", "message", "isFatal"])
        CAPLog.print("Klarna KCO plugin event: " + errorParams.description)
        self.notifyWeb(key: "error", data: errorParams)
    }
}

// Setup Klarna SDK
extension KlarnaKco {
    func initKlarnaSdk() {
        if self.checkout !== nil {
            return
        }
        
        // Checkout view configuration
        self.checkout = KlarnaCheckoutView(returnURL: self.config.iosReturnUrl!, eventHandler: self)
        self.checkout?.checkoutOptions?.merchantHandlesEPM = self.config.handleEPM
        self.checkout?.checkoutOptions?.merchantHandlesValidationErrors = self.config.handleValidationErrors
        self.checkout?.loggingLevel = self.config.loggingLevel
    }
}

extension KlarnaKco: NotificationBannerDelegate {
    func notificationBannerWillAppear(_ banner: BaseNotificationBanner) {
        self.notifyWeb(key: "bannerWillShow", data: nil)
        
        let bannerHeight = banner.bannerHeight

        CAPLog.print("Klarna KCO plugin: Banner will show with height of " + bannerHeight.description + "px")

        self.checkoutViewController?.animateHeight(height: bannerHeight)
    }
    
    func notificationBannerDidAppear(_ banner: BaseNotificationBanner) {
        self.notifyWeb(key: "bannerDidShow", data: nil)
    }
    
    func notificationBannerWillDisappear(_ banner: BaseNotificationBanner) {
        self.notifyWeb(key: "bannerWillDissapear", data: nil)
        CAPLog.print("Klarna KCO plugin: Banner will hide")

        self.checkoutViewController?.animateHeight(height: 0)
    }
    
    func notificationBannerDidDisappear(_ banner: BaseNotificationBanner) {
        self.notifyWeb(key: "bannerDidDissapear", data: nil)
    }
}
