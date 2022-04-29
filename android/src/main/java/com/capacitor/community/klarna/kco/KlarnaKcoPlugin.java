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

    public void handleListeners(String key, JSObject data) {
        notifyListeners(key, data);
    }

    private KlarnaKcoConfig getKlarnaKcoConfig() {
        KlarnaKcoConfig config = new KlarnaKcoConfig();

        String androidReturnUrl = getConfig().getString("androidReturnUrl", config.getAndroidReturnUrl());
        config.setAndroidReturnUrl(androidReturnUrl);

        return config;
    }
}
