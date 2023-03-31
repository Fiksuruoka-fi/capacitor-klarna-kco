import type { PluginListenerHandle } from '@capacitor/core';

export interface KlarnaKcoPlugin {
  /**
   * Initializes Klarna SDK with the configs.
   *
   * @since 2.0.0
   * @example
   * ```js
   *  await KlarnaKco.initialize()
   * ```
   */
  initialize(): Promise<void>;

  /**
   * Sets KCO snippet for Klarna SDK to load.
   *
   * @since 2.0.0
   * @example
   * ```js
   *  await KlarnaKco.setSnippet()
   * ```
   */
  setSnippet(options: SetSnippetOptions): Promise<CallResult>;

  /**
   * Open KCO view which includes the snippet.
   *
   * @since 2.0.0
   * @example
   * ```js
   *  await KlarnaKco.open()
   * ```
   */
  open(): Promise<CallResult>;

  /**
   * Close KCO view including the snippet.
   *
   * @since 2.0.0
   * @example
   * ```js
   *  await KlarnaKco.close()
   * ```
   */
  close(): Promise<CallResult>;

  /**
   * Destroy Klarna SDK instance.
   *
   * @since 1.0.0
   * @example
   * ```js
   *  await KlarnaKco.destroy()
   * ```
   */
  destroy(): Promise<void>;

  /**
   * Resume interactions on Klarna Checkout widget.
   *
   * @since 1.0.0
   * @see https://docs.klarna.com/in-app/checkout-sdk/checkout-ios-overview/adding-klarna-checkout-sdk-to-your-app-native-integration/#suspend-and-resume-checkout
   * @example
   * ```js
   *  await KlarnaKco.resume()
   * ```
   */
  resume(): Promise<KlarnaCallResult>;

  /**
   * Suspend interactions on Klarna Checkout widget.
   *
   * @since 1.0.0
   * @see https://docs.klarna.com/in-app/checkout-sdk/checkout-ios-overview/adding-klarna-checkout-sdk-to-your-app-native-integration/#suspend-and-resume-checkout
   * @example
   * ```js
   *  await KlarnaKco.suspend()
   * ```
   */
  suspend(): Promise<KlarnaCallResult>;

  /**
   * Listen for when the payment created.
   *
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.Complete,
    listenerFunc: (data: EventData[EventsEnum.Complete]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when KCO should redirect for external payment.
   *
   * **Requires `handleEPM` config to be `true`**
   * @since 2.0.0
   */
  addListener(
    eventName: EventsEnum.External,
    listenerFunc: (data: EventData[EventsEnum.External]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the KCO iframe has been created successfully.
   *
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.Load,
    listenerFunc: (data: EventData[EventsEnum.Load]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the user has interacted with the KCO iframe.
   *
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.UserInteracted,
    listenerFunc: (data: EventData[EventsEnum.UserInteracted]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the user has interacted with the KCO iframe.
   *
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.Customer,
    listenerFunc: (data: EventData[EventsEnum.Customer]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when organization type (B2B or Person) was changed.
   *
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.Change,
    listenerFunc: (data: EventData[EventsEnum.Change]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when postal code, country or email was changed.
   *
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.BillingAddressChange,
    listenerFunc: (data: EventData[EventsEnum.BillingAddressChange]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when shipping address was submitted.
   *
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.ShippingAddressChange,
    listenerFunc: (data: EventData[EventsEnum.ShippingAddressChange]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the user has selected a new shipping option.
   *
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.ShippingOptionChanged,
    listenerFunc: (data: EventData[EventsEnum.ShippingOptionChanged]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when we got changes on the cart from the merchant.
   *
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.OrderTotalChange,
    listenerFunc: (data: EventData[EventsEnum.OrderTotalChange]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when a checkbox was checked/unchecked.
   *
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.CheckboxChange,
    listenerFunc: (data: EventData[EventsEnum.CheckboxChange]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for network error in KCO iframe.
   *
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.NetworkError,
    listenerFunc: (data: EventData[EventsEnum.NetworkError]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the user is about to be redirected to the confirmation page.
   *
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.RedirectInitiated,
    listenerFunc: (data: EventData[EventsEnum.RedirectInitiated]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the confirmation iframe has been created succesfully.
   *
   * @see https://docs.klarna.com/klarna-checkout/in-depth-knowledge/analytics/
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.LoadConfirmation,
    listenerFunc: (data: EventData[EventsEnum.LoadConfirmation]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the external payment method is set.
   * @since 1.0.0
   */
  addListener(
    eventName: EventsEnum.External,
    listenerFunc: (data: EventData[EventsEnum.External]) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
}

export interface SetSnippetOptions {
  /**
   * The KCO frame's snippet from Klarna
   *
   * @since 2.0.0
   */
  snippet: string;
}

export interface CallResult {
  /**
   * Return status of the call
   *
   * @since 2.0.0
   */
  status: boolean;

  /**
   * Corresponding message for status value
   *
   * @since 2.0.0
   */
  message: string;
}

export interface KlarnaCallResult {
  result: 'invoked';
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

    /**
     * Set true if willing to handle validation external payment methods in your application
     *
     * @since 2.0.0
     * @default false
     * @example false
     */
    handleEPM?: boolean;

    /**
     * Set KCO native SDK logging level.
     *
     * @since 2.0.0
     * @default "off"
     * @example "verbose"
     */
    loggingLevel?: LoggingLevelsEnum;

    /**
     * Set KCO native SDK's region.
     *
     * @since 2.0.0
     * @default "eu"
     * @example "na"
     */
    region?: RegionsEnum;

    /**
     * Set KCO native environment.
     *
     * @since 2.0.0
     * @default "playground"
     * @example "production"
     */
    environment?: EnvironmentsEnum;

    /**
     * Set KCO native theme color.
     *
     * @since 2.0.0
     * @default "light"
     * @example "automatic"
     */
    theme?: ThemesEnum;
  };
}

export interface EventData {
  [EventsEnum.BillingAddressChange]: { postal_code: string; country: string };
  [EventsEnum.Change]: { email: string; postal_code: string; country: string };
  [EventsEnum.CheckboxChange]: { key: string; checked: boolean };
  [EventsEnum.Complete]: { url: string; path: string };
  [EventsEnum.Customer]: { type: string };
  [EventsEnum.External]: { url: string; path: string };
  [EventsEnum.LoadConfirmation]: Record<string, never>;
  [EventsEnum.Load]: {
    customer: EventData[EventsEnum.Customer];
    shipping_address: { country: string; postal_code: string };
  };
  [EventsEnum.NetworkError]: Record<string, never>;
  [EventsEnum.OrderTotalChange]: { order_total: number };
  [EventsEnum.RedirectInitiated]: true;
  [EventsEnum.ShippingAddressChange]: { postal_code: string; country: string };
  [EventsEnum.ShippingAddressUpdateError]: Record<string, never>;
  [EventsEnum.ShippingOptionChanged]: {
    description: string;
    id: string;
    name: string;
    price: number;
    promo: string;
    tax_amount: number;
    tax_rate: number;
  };
  [EventsEnum.UserInteracted]: { type: string };
}

export enum LoggingLevelsEnum {
  Verbose = 'verbose',
  Error = 'error',
  Off = 'off',
}

export enum RegionsEnum {
  NA = 'na',
  OC = 'oc',
  EU = 'eu',
}

export enum EnvironmentsEnum {
  Demo = 'demo',
  Playground = 'playground',
  Staging = 'staging',
  Production = 'production',
}

export enum ThemesEnum {
  Automatic = 'automatic',
  Dark = 'dark',
  Light = 'light',
}

export enum EventsEnum {
  BillingAddressChange = 'billing_address_change',
  Change = 'change',
  CheckboxChange = 'checkbox_change',
  Complete = 'complete',
  Customer = 'customer',
  External = 'external',
  Load = 'load',
  LoadConfirmation = 'load_confirmation',
  NetworkError = 'network_error',
  OrderTotalChange = 'order_total_change',
  RedirectInitiated = 'redirect_initiated',
  ShippingAddressChange = 'shipping_address_change',
  ShippingAddressUpdateError = 'shipping_address_update_error',
  ShippingOptionChanged = 'shipping_option_changed',
  UserInteracted = 'user_interacted',
}
