import Foundation
import Capacitor
import os
import UIKit
import KlarnaMobileSDK

class KlarnaKco: NSObject {
    private let config: KlarnaKcoConfig
    private let bridge: CAPBridgeProtocol
    private let plugin: KlarnaKcoPlugin
    public var opened = false
    public var checkout: KlarnaCheckoutView?
    public var sdk: KlarnaHybridSDK?
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
        DispatchQueue.main.async {
            CAPLog.print("Klarna KCO plugin: Initialize")

            if self.checkoutViewController == nil {
                self.checkoutViewController = KlarnaKcoViewController()
            }

            self.initKlarnaHybridSdk()
        }
    }
    
    @objc
    func setSnippet(snippet: String) {
        DispatchQueue.main.async {
            CAPLog.print("Klarna KCO plugin: Set snippet on view")
            self.checkout?.setSnippet(snippet)
        }
    }
    
    @objc
    func open() {
        DispatchQueue.main.async {
            if self.checkoutViewController == nil {
                CAPLog.print("Klarna KCO plugin: Checkout view is not initialized")
                return
            }
            
            if self.checkoutViewController?.presentingViewController != nil {
                CAPLog.print("Klarna KCO plugin: Checkout view is already open")
                return
            }

            self.checkoutViewController?.addKcoView(kco: self, kcoView: self.checkout!)
            self.bridge.viewController?.present(self.checkoutViewController!, animated: true, completion: nil)
        }
    }
    
    @objc
    func close() {
        DispatchQueue.main.async {
            if !(self.checkoutViewController?.presentingViewController != nil) {
                if self.checkoutViewController == nil {
                    CAPLog.print("Klarna KCO plugin: Checkout view is not initialized")
                } else {
                    CAPLog.print("Klarna KCO plugin: Checkout view is not open")
                }
                return
            }

            CAPLog.print("Klarna KCO plugin: Close checkout view")
            self.checkoutViewController?.dismiss(animated: true)
        }
    }
    
    @available(iOS 15.0, *)
    @objc
    func expand() {
        DispatchQueue.main.async {
            CAPLog.print("Klarna KCO plugin: Expand view")
            self.checkoutViewController?.expand()
        }
    }
    
    @objc
    func resume() {
        CAPLog.print("Klarna KCO plugin: Resume widget")
        self.checkout?.resume()
    }
    
    @objc
    func suspend() {
        CAPLog.print("Klarna KCO plugin: Suspend widget")
        self.checkout?.suspend()
    }
    
    @objc
    func destroy() {
        DispatchQueue.main.async {
            CAPLog.print("Klarna KCO plugin: Close checkout view")
            self.checkoutViewController?.dismiss(animated: true)

            CAPLog.print("Klarna KCO plugin: Destroy checkout")
            self.checkoutViewController?.destroy()
            self.checkoutViewController = nil

            self.checkout?.removeFromSuperview()
            self.checkout = nil
        }
    }
    
    @objc
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
    func initKlarnaHybridSdk() {
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
