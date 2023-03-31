import UIKit
import KlarnaMobileSDK
import Capacitor

class KlarnaKcoViewController: UIViewController {
    public let scrollView = UIScrollView()
    public var contentView: KlarnaCheckoutView?
    private var implementation: KlarnaKco?
    private var initialHeight: CGFloat?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.initialHeight = view.bounds.height

        view.backgroundColor = .white
        view.addSubview(scrollView)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        self.scrollView.frame = view.bounds
        self.contentView?.frame = scrollView.bounds
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
    
    @objc func animateHeight(height: CGFloat) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                var frame = self.view.frame
                if (height > 0) {
                    let statusBarHeight = self.view.window?.windowScene?.statusBarManager?.statusBarFrame.height ?? 0
                    frame.origin.y += height - statusBarHeight
                    frame.size.height -= height - statusBarHeight
                } else {
                    frame.origin.y = 0
                    frame.size.height = self.initialHeight!
                }
                
                self.view.frame = frame
            }, completion: { _ in
                self.scrollView.layoutIfNeeded()
                self.contentView?.layoutIfNeeded()
            })
        }
    }
}
