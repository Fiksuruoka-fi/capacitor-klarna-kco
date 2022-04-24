package com.capacitor.community.klarna.kco;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

@CapacitorPlugin(name = "KlarnaKco")
public class KlarnaKcoPlugin extends Plugin {
    private KlarnaKco implementation;
    private KlarnaKcoConfig config;

    public void load() {
        config = getKlarnaKcoConfig("", "");

        if (config.getInApp()) {
            KlarnaKcoPlugin plugin = this;
            getActivity()
                    .runOnUiThread(
                            () -> {
                                implementation = new KlarnaKco(config, plugin);
                            }
                    );
        }
    }

    @PluginMethod
    public void alert(PluginCall call) {
        String title = call.getString("title");
        String message = call.getString("message");

        implementation.alert(title, message);
        call.resolve();
    }

    @PluginMethod
    public void destroy(PluginCall call) {
        getActivity()
                .runOnUiThread(
                        () -> {
                            implementation.destroyKlarna();
                            call.resolve();
                        }
                );
    }

    @PluginMethod
    public void initialize(PluginCall call) {
        String snippet = call.getString("snippet");
        String checkoutUrl = call.getString("checkoutUrl");

        config = getKlarnaKcoConfig(snippet, checkoutUrl);

        KlarnaKcoPlugin plugin = this;
        getActivity()
                .runOnUiThread(
                        () -> {
                            // Check if KCO is already opened in separate browser window
                            if (implementation != null && implementation.browser != null && implementation.browser.getLoaded()) {
                                // Check if snippet was used and set it again
                                if (snippet != null && !snippet.isEmpty()) {
                                    implementation.checkout.setSnippet(snippet);
                                }

                                // Otherwise set webView to SDK again
                                else {
                                    implementation.checkout.setWebView(implementation.browser.getKlarnaWebView());
                                }
                            }

                            // Otherwise check if KCO sdk is already initialized and use current viewController and set webview to SDK again
                            else if (implementation != null && implementation.checkout != null) {
                                // implementation.checkout.setWebView(bridge.getWebView());
                            }

                            // Otherwise initialize KCO SDK
                            else {
                                implementation = new KlarnaKco(config, plugin);
                            }
                        }
                );

        call.resolve();
    }

    @PluginMethod
    public void loaded(PluginCall call) {
        call.unimplemented("Not implemented on Android.");
    }

    @PluginMethod
    public void resume(PluginCall call) {
        implementation.resume();
        call.resolve();
    }

    @PluginMethod
    public void suspend(PluginCall call) {
        implementation.suspend();
        call.resolve();
    }

    public void handleListeners(String key, JSObject data) {
        notifyListeners(key, data);
    }

    private KlarnaKcoConfig getKlarnaKcoConfig(String snippet, String checkoutUrl) {
        KlarnaKcoConfig config = new KlarnaKcoConfig();

        Boolean inApp = getConfig().getBoolean("inApp", config.getInApp());
        config.setInApp(inApp);

        String androidReturnUrl = getConfig().getString("androidReturnUrl", config.getAndroidReturnUrl());
        config.setAndroidReturnUrl(androidReturnUrl);

        Boolean handleConfirmation = getConfig().getBoolean("handleConfirmation", config.getHandleConfirmation());
        config.setHandleConfirmation(handleConfirmation);

        String title = getConfig().getString("title", config.getTitle());
        config.setTitle(title);

        String barColor = getConfig().getString("barColor", "white");
        config.setBarColor(barColor);

        String barItemColor = getConfig().getString("barItemColor", "red");
        config.setBarItemColor(barItemColor);

        String cancelText = getConfig().getString("cancelText", config.getCancelText());
        config.setCancelText(cancelText);

        if (snippet != null && !snippet.isEmpty()) {
            config.setSnippet(snippet);
        }

        if (checkoutUrl != null && !checkoutUrl.isEmpty()) {
            config.setCheckoutUrl(checkoutUrl);
        }

        return config;
    }
}
