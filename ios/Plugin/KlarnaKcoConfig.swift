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
    var cancelText: String = "Cancel".localized(.UIKit)
}

public extension String {
    func localized(_ bundle: Bundle = .main) -> String {
        bundle.localize(self)
    }
    var localized: String {
        return localized()
    }
}

extension Bundle {
    static var UIKit: Bundle {
        Self(for: UIApplication.self)
    }
    func localize(_ key: String, table: String? = nil) -> String {
        self.localizedString(forKey: key, value: nil, table: nil)
    }
    var localizableStrings: [String: String]? {
        guard let fileURL = url(forResource: "Localizable", withExtension: "strings") else {
            return nil
        }
        do {
            let data = try Data(contentsOf: fileURL)
            let plist = try PropertyListSerialization.propertyList(from: data, format: .none)
            return plist as? [String: String]
        } catch {
            print(error)
        }
        return nil
    }
}
