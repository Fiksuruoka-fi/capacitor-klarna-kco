package com.capacitor.community.klarna.kco

import android.app.Activity
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
import java.util.concurrent.atomic.AtomicReference

class KlarnaKco(private val config: KlarnaKcoConfig, var plugin: KlarnaKcoPlugin) {
    private val bridge: Bridge? = plugin.bridge
    private var checkoutView: KlarnaKcoView? = null
    var checkout: KlarnaCheckoutView? = null

    private fun initialize() {
        val activity: Activity = plugin.activity
        activity.runOnUiThread {
            Logger.debug("Klarna KCO plugin", "Initialize")

            initKlarnaSdk()

            if (this.checkoutView == null) {
                this.checkoutView = KlarnaKcoView(this.checkout!!)
            }
        }
    }

    fun setSnippet(snippet: String?): JSObject {
        val activity: Activity = plugin.activity
        val message = AtomicReference("")
        val status = AtomicReference(false)
        val checkout = checkout
        activity.runOnUiThread {
            if (checkout == null) {
                message.set("Checkout SDK not initialized")
                return@runOnUiThread
            }
            checkout.setSnippet(snippet!!)
            status.set(true)
            message.set("Set snippet on checkout view")
        }
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
        val kco = this

        activity.runOnUiThread {
            if (checkoutView == null) {
                message.set("Checkout view is not initialized")
                return@runOnUiThread
            }

            if (bridge == null) {
                message.set("Bridge view is not initialized")
                return@runOnUiThread
            }
            /**
             * if (checkoutView.isOpen) {
             * message.set("Checkout view is already open");
             * return;
             * }
             */
            if (checkout == null) {
                message.set("Checkout not initialized")
            }

            val supportFragmentManager = plugin.activity.supportFragmentManager
            checkoutView!!.show(supportFragmentManager, KlarnaKcoView.TAG)
            /**
             * checkoutView.addKcoView(kco, checkout);
             * checkoutView.presentView();
             */
            message.set("Opened checkout view")
            status.set(true)
        }
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
        activity.runOnUiThread {
            /**
             * if (checkoutView == null) {
             * message.set("Checkout view is not initialized");
             * return;
             * }
             *
             * if (!checkoutView.isOpen) {
             * message.set("Checkout view is not open");
             * return;
             * }
             *
             * checkoutView.dismiss();
             */
            message.set("Closed checkout view")
            status.set(true)
        }
        Logger.debug("Klarna KCO plugin", message.get())
        val ret = JSObject()
        ret.put("message", message.get())
        ret.put("status", status.get())
        return ret
    }

    fun resume() {
        Logger.debug("Klarna KCO plugin", "Resume widget")
        checkout!!.resume()
    }

    fun suspend() {
        Logger.debug("Klarna KCO plugin", "Suspend widget")
        checkout!!.suspend()
    }

    fun destroy() {
        Logger.debug("Klarna KCO plugin", "Destroy checkout")
        checkout = null
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
                        val uri = (params["uri"] as String?)!!
                        handleCompletionUri(uri)
                    }
                    "external" -> {
                        val uri = (params["uri"] as String?)!!
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

        override fun onError(klarnaComponent: KlarnaComponent, error: KlarnaMobileSDKError) {}
    }

    /**
     * Initialize KCO SDK with settings and preferences
     */
    private fun initKlarnaSdk() {
        if (checkout != null) {
            return
        }

        val checkout = KlarnaCheckoutView(
            context = this.bridge!!.context,
            returnURL = this.config.androidReturnUrl,
            eventHandler = this.eventHandler,
            environment = this.config.environment,
            region = this.config.region
        )

        checkout.checkoutOptions!!.merchantHandlesValidationErrors = this.config.handleValidationErrors
        checkout.checkoutOptions!!.merchantHandlesEPM = this.config.handleEPM

        this.checkout = checkout
    }

    init {
        initialize()
    }
}