package com.capacitor.community.klarna.kco;
import android.app.Activity;
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.content.Intent;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.klarna.checkout.KlarnaCheckout;
import com.klarna.checkout.SignalListener;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.net.HttpURLConnection;
import java.net.URL;

public class KlarnaKco extends Plugin {
    private KlarnaKcoConfig config;
    private KlarnaKcoPlugin plugin;
    public BrowserActivity browser;
    public KlarnaCheckout checkout;

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
        Activity activity = this.browser != null ? this.browser : this.bridge.getActivity();
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
        if (this.browser != null) {
            this.browser.close();
            this.browser = null;
        }
        this.checkout.destroy();
        this.checkout = null;
    }

    public void initialize() {
        initKlarnaCheckout(bridge.getActivity(), bridge.getWebView());
    }

    public void notifyWeb(String key, JSObject data) {
        notifyListeners(key, data);
    }

    public void openBrowser() {
        this.browser = new BrowserActivity(this, this.config);
        Intent intent = new Intent(Intent.ACTION_VIEW);
        this.browser.startActivity(intent);
    }

    public void resume() {
        this.checkout.resume();
    }

    public void suspend() {
        this.checkout.suspend();
    }

    /**
     * Initialize KCO SDK with settings and preferences
     */
    protected void initKlarnaCheckout(Activity activity, WebView webView) {
        //Attach Activity and WebView to checkout
        final KlarnaCheckout checkout = new KlarnaCheckout(activity, this.config.getAndroidReturnUrl());

        if (this.config.getSnippet().isEmpty()) {
            checkout.setWebView(webView);
            checkout.notify();
        } else {
            checkout.setSnippet(this.config.getSnippet());
        }

        //Attach the listener to handle event messages from checkout.
        checkout.setSignalListener(this::handleNotification);
        this.checkout = checkout;
    }

    /**
     * Handle Klarna events
     */
    protected void handleNotification(String eventName, JSONObject jsonObject) {
        if (eventName.equals("complete")) {
            try {
                handleCompletionUri(jsonObject.getString("uri"));
            } catch (JSONException e) {
                Log.e(e.getMessage(), e.toString());
            }
        } else {
            try {
                JSObject ret = JSObject.fromJSONObject(jsonObject);
                notifyWeb(eventName, ret);
            } catch (JSONException e) {
                Log.e(e.getMessage(), e.toString());
            }
        }
    }

    protected void handleCompletionUri(String uri) {
        try {
            URL url = new URL(uri);
            if (config.getHandleConfirmation()) {
                HttpURLConnection urlConnection = (HttpURLConnection) url.openConnection();
                try {
                    new BufferedInputStream(urlConnection.getInputStream());
                } finally {
                urlConnection.disconnect();
                }
            }
            JSObject ret = new JSObject();
            ret.put("url", uri);
            ret.put("path", url.getPath());
            notifyWeb("complete", ret);
        } catch (IOException e) {
            Log.e(e.getMessage(), e.toString());
        }
    }

    @Override
    protected void handleOnDestroy() {
        destroyKlarna();
        super.handleOnDestroy();
    }
}
