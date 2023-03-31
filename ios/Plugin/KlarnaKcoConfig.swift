import Foundation
import UIKit
import KlarnaMobileSDK
import NotificationBannerSwift

public struct KlarnaKcoConfig {
    var iosReturnUrl = URL.init(string: "")
    var handleValidationErrors: Bool = false
    var handleEPM: Bool = false
    var region: KlarnaRegion = KlarnaRegion.eu
    var environment: KlarnaEnvironment = KlarnaEnvironment.playground
    var loggingLevel: KlarnaLoggingLevel = KlarnaLoggingLevel.off
    var theme: KlarnaTheme = KlarnaTheme.light
}

