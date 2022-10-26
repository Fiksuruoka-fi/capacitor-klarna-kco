package com.capacitor.community.klarna.kco;

import com.getcapacitor.JSObject;
import com.getcapacitor.Plugin;
import com.getcapacitor.PluginCall;
import com.getcapacitor.PluginMethod;
import com.getcapacitor.annotation.CapacitorPlugin;

import org.json.JSONException;
import org.json.JSONObject;

import java.net.MalformedURLException;
import java.net.URL;

@CapacitorPlugin(name = "KlarnaKco")
public class KlarnaKcoPlugin extends Plugin {
    private KlarnaKco implementation;
    private KlarnaKcoConfig config;

    public void load() {
        config = getKlarnaKcoConfig();
        KlarnaKcoPlugin plugin = this;
        getActivity().runOnUiThread(() -> implementation = new KlarnaKco(config, plugin));
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
    public void resume(PluginCall call) {
        implementation.resume();
        call.resolve();
    }

    @PluginMethod
    public void suspend(PluginCall call) {
        implementation.suspend();
        call.resolve();
    }

    public void handleListeners(String key, JSObject data) throws MalformedURLException {
        if (key.equals("complete") || key.equals("external")) {
            JSObject formattedData = new JSObject();
            URL url = new URL(data.getString("uri", ""));
            if (url.toString().length() > 0) {
                formattedData.put("url", url.toString());
                formattedData.put("path", url.getPath());
            }
            notifyListeners(key, formattedData);
        } else {
            notifyListeners(key, data);
        }
    }

    private KlarnaKcoConfig getKlarnaKcoConfig() {
        KlarnaKcoConfig config = new KlarnaKcoConfig();

        String androidReturnUrl = getConfig().getString("androidReturnUrl", config.getAndroidReturnUrl());
        config.setAndroidReturnUrl(androidReturnUrl);

        Boolean handleValidationErrors = getConfig().getBoolean("handleValidationErrors", config.getHandleValidationErrors());
        config.setHandleValidationErrors(handleValidationErrors);

        Boolean handleEpm = getConfig().getBoolean("handleEPM", config.getHandleEPM());
        config.setHandleEPM(handleEpm);

        return config;
    }
}
