package com.capacitor.community.klarna.kco;
import android.content.Context;
import android.graphics.Color;

import com.getcapacitor.Plugin;

public class KlarnaKcoConfig {
    private String androidReturnUrl = "";
    private Boolean inApp = false;
    private Boolean handleConfirmation = false;
    private Boolean handleValidationErrors = false;
    private String checkoutUrl = "";
    private String snippet = "";
    private String title = "";
    private String barColor =  "white";
    private String barItemColor = "red";
    private String cancelText = "Cancel";

    public Boolean getInApp() {
        return inApp;
    }

    public void setInApp(Boolean inApp) {
        this.inApp = inApp;
    }

    public String getAndroidReturnUrl() {
        return androidReturnUrl;
    }

    public void setAndroidReturnUrl(String androidReturnUrl) {
        this.androidReturnUrl = androidReturnUrl;
    }

    public Boolean getHandleConfirmation() {
        return handleConfirmation;
    }

    public void setHandleConfirmation(Boolean handleConfirmation) {
        this.handleConfirmation = handleConfirmation;
    }

    public Boolean getHandleValidationErrors() {
        return handleValidationErrors;
    }

    public void setHandleValidationErrors(Boolean handleValidationErrors) {
        this.handleValidationErrors = handleValidationErrors;
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

    public void setTitle(String title) {
        this.title = title;
    }

    public int getBarColor() {
        return Color.parseColor(barColor);
    }

    public void setBarColor(String barColor) {
        this.barColor = barColor;
    }

    public int getBarItemColor() {
        return Color.parseColor(barItemColor);
    }

    public void setBarItemColor(String barItemColor) {
        this.barItemColor = barItemColor;
    }

    public String getCancelText() {
        return cancelText;
    }

    public void setCancelText(String cancelText) {
        this.cancelText = cancelText;
    }
}
