import UIKit
import KlarnaMobileSDK
import Capacitor

class KlarnaKcoViewController: UIViewController {
    public let scrollView = UIScrollView()
    public var contentView: KlarnaCheckoutView?
    private var implementation: KlarnaKco?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(scrollView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.frame = view.bounds
        self.contentView?.frame = scrollView.bounds
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.modalPresentationStyle = .pageSheet
        self.modalTransitionStyle = .coverVertical

        if #available(iOS 15.0, *) {
            if let presentationController = self.sheetPresentationController {
                presentationController.detents = [.medium(), .large()]
                presentationController.largestUndimmedDetentIdentifier = .medium
                presentationController.prefersGrabberVisible = true
                presentationController.delegate = self
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.implementation?.opened = true
        self.implementation?.notifyWeb(key: "opened", data: [:])
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.implementation?.opened = false
        self.implementation?.notifyWeb(key: "closed", data: [:])
    }

    @objc func addKcoView(kco: KlarnaKco, kcoView: KlarnaCheckoutView) {
        self.implementation = kco
        self.contentView = kcoView
        self.scrollView.addSubview(self.contentView!)
    }
    
    @objc func destroy() {
        contentView?.removeFromSuperview()
        contentView = nil
    }
}

@available(iOS 15.0, *)
extension KlarnaKcoViewController: UISheetPresentationControllerDelegate {
    func sheetPresentationControllerDidChangeSelectedDetentIdentifier(_ sheetPresentationController: UISheetPresentationController) {
        if let detentIdentifier = sheetPresentationController.selectedDetentIdentifier {
            self.handleDetentChange(changedTo: detentIdentifier)
        }
    }
    
    func handleDetentChange(changedTo: UISheetPresentationController.Detent.Identifier) {
        if changedTo == .large {
            CAPLog.print("Klarna KCO plugin view size changed: .large")
            self.implementation?.notifyWeb(key: "expanded", data: [
                "state": true
            ])
        } else {
            CAPLog.print("Klarna KCO plugin view size changed: .medium")
            self.implementation?.notifyWeb(key: "expanded", data: [
                "state": false
            ])
        }
    }
    
    func expand() {
        if let sheet = self.sheetPresentationController {
            sheet.animateChanges {
                sheet.largestUndimmedDetentIdentifier = .large
                sheet.selectedDetentIdentifier = .large
                self.handleDetentChange(changedTo: .large)
            }
        }
    }
}
