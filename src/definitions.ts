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
    eventName: EventsEnum.Complete,
    listenerFunc: (data: EventData[EventsEnum.Complete]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the KCO iframe has been created successfully.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.Load,
    listenerFunc: (data: EventData[EventsEnum.Load]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the user has interacted with the KCO iframe.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.UserInteracted,
    listenerFunc: (data: EventData[EventsEnum.UserInteracted]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the user has interacted with the KCO iframe.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.Customer,
    listenerFunc: (data: EventData[EventsEnum.Customer]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when organization type (B2B or Person) was changed.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.Change,
    listenerFunc: (data: EventData[EventsEnum.Change]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when postal code, country or email was changed.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.BillingAddressChange,
    listenerFunc: (data: EventData[EventsEnum.BillingAddressChange]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when shipping address was submitted.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.ShippingAddressChange,
    listenerFunc: (data: EventData[EventsEnum.ShippingAddressChange]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the user has selected a new shipping option.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.ShippingOptionChanged,
    listenerFunc: (data: EventData[EventsEnum.ShippingOptionChanged]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when we got changes on the cart from the merchant.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.OrderTotalChange,
    listenerFunc: (data: EventData[EventsEnum.OrderTotalChange]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when a checkbox was checked/unchecked.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.CheckboxChange,
    listenerFunc: (data: EventData[EventsEnum.CheckboxChange]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for network error in KCO iframe.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.NetworkError,
    listenerFunc: (data: EventData[EventsEnum.NetworkError]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the user is about to be redirected to the confirmation page.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.RedirectInitiated,
    listenerFunc: (data: EventData[EventsEnum.RedirectInitiated]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the confirmation iframe has been created succesfully.
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.LoadConfirmation,
    listenerFunc: (data: EventData[EventsEnum.LoadConfirmation]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
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

export interface EventData {
  [EventsEnum.Complete]: {
    url: string;
  };
  [EventsEnum.Load]: {
    customer: EventData[EventsEnum.Customer];
    shipping_address: {
      country: string;
      postal_code: string;
    };
  };
  [EventsEnum.UserInteracted]: {
    type: string;
  };
  [EventsEnum.Customer]: {
    type: string;
  };
  [EventsEnum.Change]: {
    email: string;
    postal_code: string;
    country: string;
  };
  [EventsEnum.BillingAddressChange]: {
    postal_code: string;
    country: string;
  };
  [EventsEnum.ShippingAddressChange]: {
    postal_code: string;
    country: string;
  };
  [EventsEnum.ShippingOptionChanged]: {
    description: string;
    id: string;
    name: string;
    price: number;
    promo: string;
    tax_amount: number;
    tax_rate: number;
  };
  [EventsEnum.ShippingAddressUpdateError]: Record<string, never>;
  [EventsEnum.OrderTotalChange]: {
    order_total: number;
  };
  [EventsEnum.CheckboxChange]: {
    key: string;
    checked: boolean;
  };
  [EventsEnum.NetworkError]: Record<string, never>;
  [EventsEnum.RedirectInitiated]: true;
  [EventsEnum.LoadConfirmation]: Record<string, never>;
}

export enum EventsEnum {
  Complete = 'complete',
  Load = 'load',
  UserInteracted = 'user_interacted',
  Customer = 'customer',
  Change = 'change',
  BillingAddressChange = 'billing_address_change',
  ShippingAddressChange = 'shipping_address_change',
  ShippingOptionChanged = 'shipping_option_changed',
  ShippingAddressUpdateError = 'shipping_address_update_error',
  OrderTotalChange = 'order_total_change',
  CheckboxChange = 'checkbox_change',
  NetworkError = 'network_error',
  RedirectInitiated = 'redirect_initiated',
  LoadConfirmation = 'load_confirmation',
}
