import Foundation
import UIKit

public struct KlarnaKcoConfig {
    var iosReturnUrl = URL.init(string: "")
    var handleConfirmation: Bool = false
    var handleValidationErrors: Bool = false
    var checkoutUrl: String = ""
    var snippet: String = ""
    var title: String = ""
    var barColor: UIColor = .white
    var barItemColor: UIColor = .red
}
