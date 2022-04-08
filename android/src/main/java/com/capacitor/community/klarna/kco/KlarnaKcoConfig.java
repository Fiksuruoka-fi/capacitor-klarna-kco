package com.capacitor.community.klarna.kco;
import android.graphics.Color;

import com.getcapacitor.Plugin;

public class KlarnaKcoConfig extends Plugin {
    private final String androidReturnUrl = getConfig().getString("androidReturnUrl", "");
    private final Boolean handleConfirmation = getConfig().getBoolean("handleConfirmation", false);
    private final Boolean handleValidationErrors = getConfig().getBoolean("handleValidationErrors", false);
    private String checkoutUrl = "";
    private String snippet = "";
    private final String title = getConfig().getString("title", "");
    private final int barColor = Color.parseColor(getConfig().getString("barColor", "white"));
    private final int barItemColor = Color.parseColor(getConfig().getString("barItemColor", "red"));
    private final String cancelText = getConfig().getString("cancelText", this.bridge.getContext().getString(R.string.cancel));

    public String getAndroidReturnUrl() {
        return androidReturnUrl;
    }

    public Boolean getHandleConfirmation() {
        return handleConfirmation;
    }

    public Boolean getHandleValidationErrors() {
        return handleValidationErrors;
    }

    public String getCheckoutUrl() {
        return checkoutUrl;
    }

    public void setCheckoutUrl(String checkoutUrl) {
        this.checkoutUrl = checkoutUrl;
    }

    public String getSnippet() {
        return snippet;
    }

    public void setSnippet(String snippet) {
        this.snippet = snippet;
    }

    public String getTitle() {
        return title;
    }

    public int getBarColor() {
        return barColor;
    }

    public int getBarItemColor() {
        return barItemColor;
    }

    public String getCancelText() {
        return cancelText;
    }
}
