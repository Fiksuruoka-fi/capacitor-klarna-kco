package com.capacitor.community.klarna.kco

import com.klarna.mobile.sdk.api.KlarnaEnvironment
import com.klarna.mobile.sdk.api.KlarnaLoggingLevel
import com.klarna.mobile.sdk.api.KlarnaRegion
import com.klarna.mobile.sdk.api.KlarnaTheme

class KlarnaKcoConfig {
    var androidReturnUrl = ""
    var handleValidationErrors = false
    var handleEPM = false
    var loggingLevel = KlarnaLoggingLevel.Off
    var region = KlarnaRegion.EU
    var environment = KlarnaEnvironment.PLAYGROUND
    var theme = KlarnaTheme.LIGHT
}