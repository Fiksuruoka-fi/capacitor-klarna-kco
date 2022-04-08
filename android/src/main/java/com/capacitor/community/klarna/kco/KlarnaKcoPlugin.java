package com.capacitor.community.klarna.kco;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "KlarnaKco")
public class KlarnaKcoPlugin extends Plugin {
    private KlarnaKco implementation;
    private KlarnaKcoConfig config = new KlarnaKcoConfig();

    @PluginMethod
    public void alert(PluginCall call) {
        String title = call.getString("title");
        String message = call.getString("message");

        implementation.alert(title, message);
        call.resolve();
    }

    @PluginMethod
    public void destroy(PluginCall call) {
        this.implementation.destroyKlarna();
        call.resolve();
    }

    @PluginMethod
    public void initialize(PluginCall call) {
        String snippet = call.getString("snippet");
        String checkoutUrl = call.getString("checkoutUrl");

        // Check if KCO is already opened in separate browser window
        if (this.implementation.browser != null && this.implementation.browser.getLoaded()) {
            // Check if snippet was used and set it again
            if (snippet != null && !snippet.isEmpty()) {
                this.implementation.checkout.setSnippet(snippet);
            }

            // Otherwise set webView to SDK again
            else {
                this.implementation.checkout.setWebView(this.implementation.browser.getKlarnaWebView());
            }
        }

        // Otherwise check if KCO sdk is already initialized and use current viewController and set webview to SDK again
        else if (this.implementation.checkout != null) {
            this.implementation.checkout.setWebView(this.bridge.getWebView());
        }

        // Otherwise initialize KCO SDK
        else {
            this.implementation = new KlarnaKco(this.config, this);
        }

        call.resolve();
    }

    @PluginMethod
    public void loaded(PluginCall call) {
        call.unimplemented("Not implemented on Android.");
    }

    @PluginMethod
    public void resume(PluginCall call) {
        this.implementation.resume();
        call.resolve();
    }

    @PluginMethod
    public void suspend(PluginCall call) {
        this.implementation.suspend();
        call.resolve();
    }
}
