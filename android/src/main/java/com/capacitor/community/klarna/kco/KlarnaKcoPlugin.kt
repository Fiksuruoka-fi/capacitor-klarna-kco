package com.capacitor.community.klarna.kco

import com.getcapacitor.*
import com.getcapacitor.annotation.CapacitorPlugin
import com.klarna.mobile.sdk.api.KlarnaEnvironment
import com.klarna.mobile.sdk.api.KlarnaLoggingLevel
import com.klarna.mobile.sdk.api.KlarnaRegion

@CapacitorPlugin(name = "KlarnaKco")
class KlarnaKcoPlugin : Plugin() {
    private var implementation: KlarnaKco? = null
    private val config = KlarnaKcoConfig()

    @PluginMethod
    fun initialize(call: PluginCall) {
        setKlarnaKcoConfig()
        implementation = KlarnaKco(config, this)
        call.resolve()
    }

    @PluginMethod
    fun setSnippet(call: PluginCall) {
        if (this.implementation == null) {
            call.reject("Klarna plugin not initialized")
            return
        }
        try {
            val snippet = call.getString("snippet", "")
            if (snippet?.isEmpty() == true) {
                call.reject("Snippet was empty")
                return
            }

            val result = this.implementation?.setSnippet(snippet!!)
            if (result != null) {
                val status = result.getBoolean("status", false)
                if (status != null && status) call.resolve(result) else call.reject(result.getString("message"))
            } else call.reject("Error in getting the result")
        } catch (e: Exception) {
            call.reject("An error occurred while setting Klarna checkout snippet: " + e.message)
            Logger.error(e.message, e)
        }
    }

    @PluginMethod
    fun open(call: PluginCall) {
        if (this.implementation == null) {
            call.reject("Klarna plugin not initialized")
            return
        }
        try {
            val result = this.implementation?.open()
            if (result != null) {
                val status = result.getBoolean("status", false)
                if (status != null && status) call.resolve(result) else call.reject(result.getString("message"))
            } else call.reject("Error in getting the result")
        } catch (e: Exception) {
            call.reject("An error occurred while opening Klarna checkout view: " + e.message)
            Logger.error(e.message, e)
        }
    }

    @PluginMethod
    fun close(call: PluginCall) {
        if (this.implementation == null) {
            call.reject("Klarna plugin not initialized")
            return
        }
        try {
            val result = this.implementation?.close()
            if (result != null) {
                val status = result.getBoolean("status", false)
                if (status != null && status) call.resolve(result) else call.reject(result.getString("message"))
            } else call.reject("Error in getting the result")
        } catch (e: Exception) {
            call.reject("An error occurred while closing Klarna checkout view: " + e.message)
            Logger.error(e.message, e)
        }
    }

    @PluginMethod
    fun resume(call: PluginCall) {
        if (this.implementation == null) {
            call.reject("Klarna plugin not initialized")
            return
        }
        this.implementation?.resume()
        val ret = JSObject()
        ret.put("result", "invoked")
        call.resolve(ret)
    }

    @PluginMethod
    fun suspend(call: PluginCall) {
        if (this.implementation == null) {
            call.reject("Klarna plugin not initialized")
            return
        }
        this.implementation?.suspend()
        val ret = JSObject()
        ret.put("result", "invoked")
        call.resolve(ret)
    }

    @PluginMethod
    fun destroy(call: PluginCall) {
        if (this.implementation == null) {
            call.reject("Klarna plugin not initialized")
            return
        }
        this.implementation?.destroy()
        call.resolve()
    }

    fun notify(key: String, data: JSObject) {
        this.notifyListeners(key, data)
    }

    private fun setKlarnaKcoConfig() {
        val androidReturnUrl = getConfig().getString("androidReturnUrl", config.androidReturnUrl)
        config.androidReturnUrl = androidReturnUrl
        val handleValidationErrors = getConfig().getBoolean("handleValidationErrors", config.handleValidationErrors)
        config.handleValidationErrors = handleValidationErrors
        val handleEpm = getConfig().getBoolean("handleEPM", config.handleEPM)
        config.handleEPM = handleEpm

        when (getConfig().getString("region", "")) {
            "na" -> config.region = KlarnaRegion.NA
            "oc" -> config.region = KlarnaRegion.OC
            "eu" -> config.region = KlarnaRegion.EU
            else -> {}
        }

        when (getConfig().getString("environment", "")) {
            "demo" -> config.environment = KlarnaEnvironment.DEMO
            "playground" -> config.environment = KlarnaEnvironment.PLAYGROUND
            "staging" -> config.environment = KlarnaEnvironment.STAGING
            "production" -> config.environment = KlarnaEnvironment.PRODUCTION
            else -> {}
        }

        when (getConfig().getString("loggingLevel", "")) {
            "verbose" -> config.loggingLevel = KlarnaLoggingLevel.Verbose
            "error" -> config.loggingLevel = KlarnaLoggingLevel.Error
            "off" -> config.loggingLevel = KlarnaLoggingLevel.Off
            else -> {}
        }
    }
}