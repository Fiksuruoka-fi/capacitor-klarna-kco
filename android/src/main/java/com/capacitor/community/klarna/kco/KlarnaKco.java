package com.capacitor.community.klarna.kco;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.util.Log;
import android.webkit.WebView;

import com.getcapacitor.JSObject;
import com.klarna.checkout.KlarnaCheckout;
import com.klarna.checkout.SignalListener;

import org.json.JSONException;
import org.json.JSONObject;

public class KlarnaKco {
    private final KlarnaKcoConfig config;
    private final KlarnaKcoPlugin plugin;
    public BrowserActivity browser = null;
    public KlarnaCheckout checkout = null;

    public KlarnaKco(KlarnaKcoConfig config, KlarnaKcoPlugin plugin) {
        this.config = config;
        this.plugin = plugin;

        if (this.config.getCheckoutUrl().isEmpty() && this.config.getSnippet().isEmpty()) {
            initialize();
        } else {
            openBrowser();
        }
    }

    public void alert(String title, String message) {
        Activity activity = browser != null ? browser : plugin.getBridge().getActivity();
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        builder.setTitle(title).setMessage(message).setPositiveButton(R.string.ok, new DialogInterface.OnClickListener() {
            public void onClick(DialogInterface dialog, int id) {
                dialog.dismiss();
            }
        });
        AlertDialog dialog = builder.create();
        dialog.show();
    }

    public void destroyKlarna() {
        if (browser != null) {
            browser.close();
            browser = null;
        }
        checkout.destroy();
        checkout = null;
    }

    public void initialize() {
        if (checkout != null) return;
        final Activity activity = plugin.getActivity();
        final WebView webView = plugin.getBridge().getWebView();
        this.checkout = initKlarnaCheckout(activity, webView, config.getAndroidReturnUrl(), "");

        this.checkout.setSignalListener(new SignalListener() {
            @Override
            public void onSignal(String eventName, JSONObject jsonObject) {
                try {
                    JSObject ret = JSObject.fromJSONObject(jsonObject);
                    notifyWeb(eventName, ret);
                } catch (JSONException e) {
                    Log.e(e.getMessage(), e.toString());
                }
            }
        });
    }

    public void openBrowser() {
        Intent intent = new Intent(plugin.getContext(), BrowserActivity.class);
        intent.putExtra("returnUrl", config.getAndroidReturnUrl());
        intent.putExtra("snippet", config.getSnippet());
        intent.putExtra("checkoutUrl", config.getCheckoutUrl());
        plugin.getContext().startActivity(intent);
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
    public static KlarnaCheckout initKlarnaCheckout(Activity activity, WebView webView, String returnUrl, String snippet) {
        //Attach Activity and WebView to checkout
        final KlarnaCheckout checkout = new KlarnaCheckout(activity, returnUrl);
        if (snippet.isEmpty()) {
            checkout.setWebView(webView);
        } else {
            checkout.setSnippet(snippet);
        }

        return checkout;
    }
}
