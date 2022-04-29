package com.capacitor.community.klarna.kco;
import android.content.Context;
import android.graphics.Color;

import com.getcapacitor.Plugin;

public class KlarnaKcoConfig {
    private String androidReturnUrl = "";
    private Boolean handleValidationErrors = false;

    public String getAndroidReturnUrl() {
        return androidReturnUrl;
    }

    public void setAndroidReturnUrl(String androidReturnUrl) {
        this.androidReturnUrl = androidReturnUrl;
    }

    public Boolean getHandleValidationErrors() {
        return handleValidationErrors;
    }

    public void setHandleValidationErrors(Boolean handleValidationErrors) {
        this.handleValidationErrors = handleValidationErrors;
    }
}
