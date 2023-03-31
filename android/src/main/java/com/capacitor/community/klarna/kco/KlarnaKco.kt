package com.capacitor.community.klarna.kco

import android.app.Activity
import android.net.Uri
import androidx.browser.customtabs.CustomTabsIntent
import com.getcapacitor.Bridge
import com.getcapacitor.JSObject
import com.getcapacitor.Logger
import com.klarna.mobile.sdk.KlarnaMobileSDKError
import com.klarna.mobile.sdk.api.KlarnaEventHandler
import com.klarna.mobile.sdk.api.KlarnaProductEvent
import com.klarna.mobile.sdk.api.checkout.KlarnaCheckoutView
import com.klarna.mobile.sdk.api.component.KlarnaComponent
import java.net.MalformedURLException
import java.net.URL
import java.util.concurrent.Semaphore
import java.util.concurrent.atomic.AtomicReference

class KlarnaKco(private val config: KlarnaKcoConfig, var plugin: KlarnaKcoPlugin) {
    private val bridge: Bridge? = plugin.bridge
    private var checkoutView: KlarnaKcoView? = null
    private val supportFragmentManager = plugin.activity.supportFragmentManager
    var checkout: KlarnaCheckoutView? = null
    var opened = false

    private fun initialize() {
        val activity: Activity = plugin.activity
        val semaphore = Semaphore(0)
        activity.runOnUiThread {
            Logger.debug("Klarna KCO plugin", "Initialize")
            initKlarnaSdk()
            semaphore.release()
        }
        semaphore.acquire()
    }

    fun setSnippet(snippet: String): JSObject {
        val activity: Activity = plugin.activity
        val message = AtomicReference("")
        val status = AtomicReference(false)
        val checkout = checkout
        val semaphore = Semaphore(0)

        activity.runOnUiThread {
            if (checkout == null) {
                message.set("Checkout SDK not initialized")
                semaphore.release()
                return@runOnUiThread
            }

            checkout.setSnippet(snippet)
            status.set(true)
            message.set("Set snippet on checkout view")
            semaphore.release()
        }
        semaphore.acquire()
        Logger.debug("Klarna KCO plugin", message.get())
        val ret = JSObject()
        ret.put("message", message.get())
        ret.put("status", status.get())
        return ret
    }

    fun open(): JSObject {
        val activity: Activity = plugin.activity
        val message = AtomicReference("")
        val status = AtomicReference(false)
        val semaphore = Semaphore(0)

        activity.runOnUiThread {
            if (checkoutView == null) {
                message.set("Checkout view is not initialized")
                semaphore.release()
                return@runOnUiThread
            }

            if (bridge == null) {
                message.set("Bridge view is not initialized")
                semaphore.release()
                return@runOnUiThread
            }

            if (opened) {
                message.set("Checkout view is already open")
                semaphore.release()
                return@runOnUiThread
            }

            if (checkout == null) {
                message.set("Checkout not initialized")
                semaphore.release()
                return@runOnUiThread
            }

            checkoutView?.show(supportFragmentManager, KlarnaKcoView.TAG)

            message.set("Opened checkout view")
            status.set(true)
            semaphore.release()
        }
        semaphore.acquire()
        Logger.debug("Klarna KCO plugin", message.get())
        val ret = JSObject()
        ret.put("message", message.get())
        ret.put("status", status.get())
        return ret
    }

    fun close(): JSObject {
        val activity: Activity = plugin.activity
        val message = AtomicReference("")
        val status = AtomicReference(false)
        val semaphore = Semaphore(0)
        activity.runOnUiThread {
            if (checkoutView == null) {
                message.set("Checkout view is not initialized")
                semaphore.release()
                return@runOnUiThread
            }

            if (!opened) {
                message.set("Checkout view is not open")
                semaphore.release()
                return@runOnUiThread
            }

            checkoutView?.dismiss()
            message.set("Closed checkout view")
            status.set(true)
            semaphore.release()
        }
        semaphore.acquire()
        Logger.debug("Klarna KCO plugin", message.get())
        val ret = JSObject()
        ret.put("message", message.get())
        ret.put("status", status.get())
        return ret
    }

    fun resume() {
        Logger.debug("Klarna KCO plugin", "Resume widget")
        checkout?.resume()
    }

    fun suspend() {
        Logger.debug("Klarna KCO plugin", "Suspend widget")
        checkout?.suspend()
    }

    fun destroy() {
        Logger.debug("Klarna KCO plugin", "Destroy checkout")

        val activity: Activity = plugin.activity
        activity.runOnUiThread {
            checkoutView?.removeCheckoutView()
            checkoutView = null
            checkout = null
        }
    }

    fun notifyWeb(key: String, data: JSObject) {
        plugin.notify(key, data)
    }

    private var eventHandler: KlarnaEventHandler = object : KlarnaEventHandler {
        @Throws(MalformedURLException::class)
        private fun handleCompletionUri(uri: String?) {
            if (uri!!.isNotEmpty()) {
                val url = URL(uri)
                val ret = JSObject()
                ret.put("url", url.toString())
                ret.put("path", url.path)
                notifyWeb("complete", ret)
            }
        }

        @Throws(MalformedURLException::class)
        private fun handleEPM(uri: String?) {
            if (uri!!.isNotEmpty()) {
                val url = URL(uri)
                val ret = JSObject()
                ret.put("url", url.toString())
                ret.put("path", url.path)
                notifyWeb("external", ret)
            }
        }

        override fun onEvent(klarnaComponent: KlarnaComponent, event: KlarnaProductEvent) {
            val action = event.action
            val params = event.params
            Logger.debug("Klarna KCO plugin event: " + event.action + ", " + params)
            try {
                when (action) {
                    "complete" -> {
                        val uri = params["uri"] as String
                        handleCompletionUri(uri)
                    }
                    "external" -> {
                        val uri = params["uri"] as String
                        handleEPM(uri)
                    }
                    else -> {
                        val ret = JSObject()
                        for ((key, value) in params) {
                            ret.put(key, value)
                        }
                        notifyWeb(action, ret)
                    }
                }
            } catch (e: MalformedURLException) {
                Logger.error(e.message, e)
            }
        }

        override fun onError(klarnaComponent: KlarnaComponent, error: KlarnaMobileSDKError) {
            Logger.debug("Klarna KCO plugin error: " + error.name + ", " + error.message)
            val ret = JSObject()
            ret.put("error", error)
            notifyWeb("error", ret)
        }


    }

    /**
     * Initialize KCO SDK with settings and preferences
     */
    private fun initKlarnaSdk() {
        if (checkout != null) {
            return
        }

        checkout = KlarnaCheckoutView(
            context = plugin.activity,
            returnURL = config.androidReturnUrl,
            eventHandler = eventHandler,
            environment = config.environment,
            region = config.region
        )

        checkout?.checkoutOptions?.merchantHandlesValidationErrors = this.config.handleValidationErrors
        checkout?.checkoutOptions?.merchantHandlesEPM = this.config.handleEPM

        if (checkoutView == null) {
            checkoutView = KlarnaKcoView(this, checkout!!)
        }
    }

    init {
        initialize()
    }
}