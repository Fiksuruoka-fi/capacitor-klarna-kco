package com.capacitor.community.klarna.kco;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;
import android.widget.FrameLayout;

import com.getcapacitor.JSObject;
import com.klarna.checkout.KlarnaCheckout;
import com.klarna.checkout.SignalListener;

import org.json.JSONException;
import org.json.JSONObject;

public class BrowserActivity extends AppCompatActivity {
    private String snippet;
    private String returnUrl;
    private String checkoutUrl;
    private WebView klarnaWebView;
    public Boolean isLoaded = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_browser);

        Button btn = findViewById(R.id.cancelButton);
        btn.setOnClickListener(v -> close());

        Intent intent = getIntent();
        returnUrl = intent.getStringExtra("returnUrl");
        snippet = intent.getStringExtra("snippet");
        checkoutUrl = intent.getStringExtra("checkoutUrl");
        if (!checkoutUrl.isEmpty()) {
            setupWebView();
            loadURL(checkoutUrl);
        } else {
            setupEmbeddedKlarnaView();
        }

        this.isLoaded = true;
    }

    private void setupEmbeddedKlarnaView() {
        final KlarnaCheckout checkout = initKlarnaCheckout(this, null, returnUrl, snippet);
        final View checkoutView = checkout.getView();
        final ViewGroup container = findViewById(R.id.checkoutContainer);
        container.addView(checkoutView);
    }

    @SuppressLint("SetJavaScriptEnabled")
    private void setupWebView() {
        klarnaWebView = findViewById(R.id.klarnaWebView);

        klarnaWebView.getSettings().setJavaScriptEnabled(true);
        klarnaWebView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
        klarnaWebView.getSettings().setBuiltInZoomControls(true);
        klarnaWebView.getSettings().setSupportZoom(true);
        klarnaWebView.setWebViewClient(new WebViewClient());
        klarnaWebView.getSettings().setLoadWithOverviewMode(false);
        klarnaWebView.getSettings().setUseWideViewPort(true);
        klarnaWebView.setScrollContainer(true);

        initKlarnaCheckout(this, klarnaWebView, returnUrl, "");
    }

    private void loadURL(String url) {
        this.klarnaWebView.loadUrl(url);
    }

    public void close() {
        this.finish();
    }

    public WebView getKlarnaWebView() {
        return klarnaWebView;
    }

    public Boolean getLoaded() {
        return isLoaded;
    }

    /**
     * Initialize KCO SDK with settings and preferences
     */
    public KlarnaCheckout initKlarnaCheckout(Activity activity, WebView webView, String returnUrl, String snippet) {
        //Attach Activity and WebView to checkout
        Log.i("KLARNA CHECKOUT", "Return url:" + returnUrl);
        final KlarnaCheckout checkout = new KlarnaCheckout(activity, returnUrl);
        if (snippet.isEmpty()) {
            Log.i("KLARNA CHECKOUT", "Set WebView");
            checkout.setWebView(webView);
        } else {
            checkout.setSnippet(snippet);
        }

        checkout.setSignalListener(new SignalListener() {
            @Override
            public void onSignal(String eventName, JSONObject jsonObject) {
                if (eventName.equals("complete")) {
                    try {
                        Log.i("KLARNA CHECKOUT", "Complete, url" + jsonObject.getString("uri"));
                        // handleCompletionUri(jsonObject.getString("uri"));
                    } catch (JSONException e) {
                        Log.e(e.getMessage(), e.toString());
                    }
                } else {
                    try {
                        JSObject ret = JSObject.fromJSONObject(jsonObject);
                        Log.i("[KLARNA CHECKOUT]", eventName);
                        // notifyWeb(eventName, ret);
                    } catch (JSONException e) {
                        Log.e(e.getMessage(), e.toString());
                    }
                }
            }
        });

        return checkout;
    }
}
