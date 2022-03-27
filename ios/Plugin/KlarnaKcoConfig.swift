import Foundation

public struct KlarnaKcoConfig {
    var iosReturnUrl = URL.init(string: "")
    var handleConfirmation: Bool = false
    var handleValidationErrors: Bool = false
    var checkoutUrl: String = ""
    var title: String = ""
}
