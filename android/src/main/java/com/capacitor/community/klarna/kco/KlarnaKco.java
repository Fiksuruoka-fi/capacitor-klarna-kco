package com.capacitor.community.klarna.kco;
import android.app.Activity;
import android.util.Log;
import android.webkit.WebView;

import com.getcapacitor.JSObject;
import com.klarna.checkout.KlarnaCheckout;

import org.json.JSONException;

public class KlarnaKco {
    private final KlarnaKcoConfig config;
    private final KlarnaKcoPlugin plugin;
    public KlarnaCheckout checkout = null;

    public KlarnaKco(KlarnaKcoConfig config, KlarnaKcoPlugin plugin) {
        this.config = config;
        this.plugin = plugin;
        initialize();
    }

    public void destroyKlarna() {
        checkout.destroy();
        checkout = null;
    }

    public void initialize() {
        if (checkout != null) return;
        final Activity activity = plugin.getActivity();
        final WebView webView = plugin.getBridge().getWebView();
        checkout = initKlarnaCheckout(activity, webView, config.getAndroidReturnUrl());
    }

    public void resume() {
        checkout.resume();
    }

    public void suspend() {
        checkout.suspend();
    }

    public void notifyWeb(String key, JSObject data) {
        plugin.handleListeners(key, data);
    }

    /**
     * Initialize KCO SDK with settings and preferences
     */
    public KlarnaCheckout initKlarnaCheckout(Activity activity, WebView webView, String returnUrl) {
        final KlarnaCheckout checkout = new KlarnaCheckout(activity, returnUrl);
        checkout.setWebView(webView);
        checkout.setSignalListener((eventName, jsonObject) -> {
            try {
                JSObject ret = JSObject.fromJSONObject(jsonObject);
                this.notifyWeb(eventName, ret);
            } catch (JSONException e) {
                Log.e(e.getMessage(), e.toString());
            }
        });

        return checkout;
    }
}
