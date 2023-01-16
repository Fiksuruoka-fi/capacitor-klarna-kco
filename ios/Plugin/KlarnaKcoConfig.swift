import Foundation
import UIKit
import KlarnaMobileSDK

public struct KlarnaKcoConfig {
    var iosReturnUrl = URL.init(string: "")
    var handleValidationErrors: Bool = false
    var handleEPM: Bool = false
    var region: KlarnaRegion = KlarnaRegion.eu
    var environment: KlarnaEnvironment = KlarnaEnvironment.playground
    var loggingLevel: KlarnaLoggingLevel = KlarnaLoggingLevel.off
}

