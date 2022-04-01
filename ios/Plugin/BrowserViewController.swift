import UIKit
import WebKit
import KlarnaCheckoutSDK

class BrowserViewController: UIViewController, WKUIDelegate, KCOCheckoutSizingDelegate {
    private let implementation: KlarnaKco
    private let config: KlarnaKcoConfig
    private var checkout: KCOKlarnaCheckout?
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false

        return webView
    }()
    
    init(config: KlarnaKcoConfig, implementation: KlarnaKco)
    {
        self.implementation = implementation
        self.config = config

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.config.title
        
        if (!self.config.checkoutUrl.isEmpty) {
            setupWebView()
            loadURL(self.config.checkoutUrl)
            self.implementation.loaded()
        } else {
            setupEmbeddedKlarnaView()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar(view: self.view)
    }
    
    func setupEmbeddedKlarnaView() {
        self.view.backgroundColor = .white
        
        let checkout = self.implementation.initKlarnaHybridSdk(self, config: self.config, webView: nil)

//        checkout.checkoutViewController.internalScrollDisabled = true
//        checkout.checkoutViewController.sizingDelegate = self
//        checkout.checkoutViewController.parentScrollView = self.view.scrollView
        
        self.checkout = checkout
        
        self.view.addSubview(checkout.checkoutViewController.view)
    }

    func setupWebView() {
        self.view.backgroundColor = .white
        self.view.addSubview(webView)
        
        NSLayoutConstraint.activate([
            webView.topAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            webView.leftAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.leftAnchor),
            webView.bottomAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            webView.rightAnchor
                .constraint(equalTo: self.view.safeAreaLayoutGuide.rightAnchor)
        ])
        
        self.checkout = self.implementation.initKlarnaHybridSdk(self, config: self.config, webView: self.webView)
    }
        
    func setupNavBar(view: UIView) {
        let navBar = UINavigationBar(frame: CGRect(x: 0, y: 0, width: view.frame.size.width, height: 44))
        
        navBar.barTintColor = self.config.barColor
        navBar.tintColor = self.config.barItemColor
        
        view.addSubview(navBar)
        
        let navItem = UINavigationItem(title: self.config.title)
        let doneItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector(cancelAction))
        navItem.leftBarButtonItem = doneItem
        
        navBar.setItems([navItem], animated: false)
    }
        
    @objc func cancelAction() {
        self.implementation.destroy()
        dismiss(animated: true)
    }

    func loadURL(_ url: String) {
        var currentURL = url
        if !currentURL.starts(with: "http://") && !currentURL.starts(with: "https://") {
            currentURL = "http://\(currentURL)"
        }
        if let url: URL = URL(string: currentURL) {
            let urlRequest: URLRequest = URLRequest(url: url)
            self.webView.load(urlRequest)
        }
    }
    
    func checkoutViewController(_ checkoutViewController: (UIViewController & KCOCheckoutViewControllerProtocol)!, didResize size: CGSize) {
        self.view.frame.size = size
    }
}
