import type { PluginListenerHandle } from '@capacitor/core';

export interface KlarnaKcoPlugin {
  /**
   * Destroy Klarna SDK
   * @since 1.0.0
   * @example
   * ```js
   *  await KlarnaKco.destroy()
   * ```
   */
  destroy(): Promise<void>;

  /**
   * Resume interactions on Klarna Checkout widget
   * @since 1.0.0
   * @see https://docs.klarna.com/in-app/checkout-sdk/checkout-ios-overview/adding-klarna-checkout-sdk-to-your-app-native-integration/#suspend-and-resume-checkout
   * @example
   * ```js
   *  await KlarnaKco.resume()
   * ```
   */
  resume(): Promise<void>;

  /**
   * Suspend interactions on Klarna Checkout widget
   * @since 1.0.0
   * @see https://docs.klarna.com/in-app/checkout-sdk/checkout-ios-overview/adding-klarna-checkout-sdk-to-your-app-native-integration/#suspend-and-resume-checkout
   * @example
   * ```js
   *  await KlarnaKco.suspend()
   * ```
   */
  suspend(): Promise<void>;

  /**
   * Listen for when the payment created.
   * @since 1.0.0
   */
  addListener(
    eventName: 'complete',
    listenerFunc: (data: { url: string }) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the KCO iframe has been created successfully.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: 'load',
    listenerFunc: (data: EventData['load']) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the user has interacted with the KCO iframe.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: 'user_interacted',
    listenerFunc: (data: EventData['user_interacted']) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the user has interacted with the KCO iframe.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: 'customer',
    listenerFunc: (data: EventData['customer']) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when organization type (B2B or Person) was changed.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: 'change',
    listenerFunc: (data: EventData['change']) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when postal code, country or email was changed.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: 'billing_address_change',
    listenerFunc: (data: EventData['billing_address_change']) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when shipping address was submitted.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: 'shipping_address_change',
    listenerFunc: (data: EventData['shipping_address_change']) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the user has selected a new shipping option.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: 'shipping_option_changed',
    listenerFunc: (data: EventData['shipping_option_changed']) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when we got changes on the cart from the merchant.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: 'order_total_change',
    listenerFunc: (data: EventData['order_total_change']) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when a checkbox was checked/unchecked.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: 'checkbox_change',
    listenerFunc: (data: EventData['checkbox_change']) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for network error in KCO iframe.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: 'network_error',
    listenerFunc: (data: EventData['network_error']) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the user is about to be redirected to the confirmation page.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: 'redirect_initiated',
    listenerFunc: (data: EventData['redirect_initiated']) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the confirmation iframe has been created succesfully.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: 'load_confirmation',
    listenerFunc: (data: EventData['load_confirmation']) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
}

export interface InitializeOptions {
  checkoutUrl?: string;
  snippet?: string;
}

export interface AlertOptions {
  title: string;
  message: string;
}

export interface EventData {
  load: {
    customer: EventData['customer'];
    shipping_address: {
      country: string;
      postal_code: string;
    };
  };
  user_interacted: {
    type: string;
  };
  customer: {
    type: string;
  };
  change: {
    email: string;
    postal_code: string;
    country: string;
  };
  billing_address_change: {
    postal_code: string;
    country: string;
  };
  shipping_address_change: {
    postal_code: string;
    country: string;
  };
  shipping_option_changed: {
    description: string;
    id: string;
    name: string;
    price: number;
    promo: string;
    tax_amount: number;
    tax_rate: number;
  };
  shipping_address_update_error: {};
  order_total_change: {
    order_total: number;
  };
  checkbox_change: {
    key: string;
    checked: boolean;
  };
  network_error: {};
  redirect_initiated: true;
  load_confirmation: {};
}

export interface PluginsConfig {
  /**
   * Klarna KCO can be configured with the following options:
   */
  KlarnaKco?: {
    /**
     * Configure the return url for Android.
     *
     * @since 1.0.0
     * @default ""
     * @example "app-return-url://"
     */
    androidReturnUrl?: string;

    /**
     * Configure the return url for the iOS.
     *
     * @since 1.0.0
     * @default ""
     * @example "app-return-url://"
     */
    iosReturnUrl?: string;

    /**
     * Set true if willing to handle validation errors in your application
     *
     * @since 1.0.0
     * @default false
     * @example false
     */
    handleValidationErrors?: boolean;
  };
}
