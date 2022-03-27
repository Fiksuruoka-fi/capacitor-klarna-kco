import UIKit
import WebKit
import KlarnaCheckoutSDK

class BrowserViewController: UIViewController, WKUIDelegate {
    var checkout: KCOKlarnaCheckout?
    let config: KlarnaKcoConfig = KlarnaKcoConfig()
    private var implementation: KlarnaKco?
    
    lazy var webView: WKWebView = {
        let webConfiguration = WKWebViewConfiguration()
        let webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        webView.translatesAutoresizingMaskIntoConstraints = false

        return webView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = self.config.title

        setupUI()
        setupNavItem()

        self.implementation?.initKlarnaHybridSdk(config: self.config, snippet: nil, webView: self.webView)
        loadURL(self.config.checkoutUrl)
        self.implementation?.loaded()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupNavBar()
    }
    
    func setupUI() {
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
    }
    
    func setupNavItem() {
        let cancelBarItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self,
                                            action: #selector(self.cancelAction))
        self.navigationItem.leftBarButtonItem = cancelBarItem
    }
        
    func setupNavBar() {
        self.navigationController?.navigationBar.barTintColor = .systemBlue
        self.navigationController?.navigationBar.tintColor = .white
    }
        
    @objc func cancelAction() {
        self.implementation?.destroy()
    }

    func loadURL(_ url: String) {
        var currentURL = url
        if !currentURL.starts(with: "http://") && !currentURL.starts(with: "https://") {
            currentURL = "http://\(currentURL)"
        }
        if let url: URL = URL(string: currentURL) {
            var urlRequest: URLRequest = URLRequest(url: url)
            self.webView.load(urlRequest)
        }
    }
}
