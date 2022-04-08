package com.capacitor.community.klarna.kco;

import androidx.appcompat.app.AppCompatActivity;

import android.annotation.SuppressLint;
import android.os.Bundle;
import android.view.View;
import android.view.ViewGroup;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Button;

public class BrowserActivity extends AppCompatActivity {
    final private KlarnaKco implementation;
    final private KlarnaKcoConfig config;
    final private WebView klarnaWebView = new WebView(this);
    public Boolean isLoaded = false;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_browser);

        Button btn = findViewById(R.id.cancelButton);
        btn.setOnClickListener(v -> this.close());

        String checkoutUrl = this.config.getCheckoutUrl();
        if (!checkoutUrl.isEmpty()) {
            setupWebView();
            loadURL(checkoutUrl);
        } else {
            setupEmbeddedKlarnaView();
        }

        this.isLoaded = true;
    }

    public BrowserActivity(KlarnaKco implementation, KlarnaKcoConfig config) {
        this.implementation = implementation;
        this.config = config;
    }

    private void setupEmbeddedKlarnaView() {
        this.implementation.initKlarnaCheckout(this, null);
        final View checkoutView = this.implementation.checkout.getView();
        final ViewGroup container = findViewById(R.id.checkoutContainer);
        container.addView(checkoutView);
    }

    @SuppressLint("SetJavaScriptEnabled")
    private void setupWebView() {
        final ViewGroup container = findViewById(R.id.checkoutContainer);
        container.addView(this.klarnaWebView);

        this.klarnaWebView.setLayoutParams(container.getLayoutParams());
        this.klarnaWebView.getSettings().setJavaScriptEnabled(true);
        this.klarnaWebView.getSettings().setJavaScriptCanOpenWindowsAutomatically(true);
        this.klarnaWebView.getSettings().setBuiltInZoomControls(true);
        this.klarnaWebView.getSettings().setSupportZoom(true);
        this.klarnaWebView.setWebViewClient(new WebViewClient());
        this.klarnaWebView.getSettings().setLoadWithOverviewMode(false);
        this.klarnaWebView.getSettings().setUseWideViewPort(true);
        this.klarnaWebView.setScrollContainer(true);

        this.implementation.initKlarnaCheckout(this, this.klarnaWebView);
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
}