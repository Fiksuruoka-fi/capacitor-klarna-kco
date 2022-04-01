import type { PluginListenerHandle } from '@capacitor/core';

export interface KlarnaKcoPlugin {
  destroy(): Promise<void>;
  initialize(options: {
    checkoutUrl?: string;
    snippet?: string;
  }): Promise<void>;
  loaded(): Promise<void>;
  deviceIdentifier(): Promise<void>;
  setLoggingLevel(options: { value: KlarnaLoggingLevel }): Promise<void>;

  /**
   * Listen for when the Klarna Checkout is complete.
   *
   * @since 1.0.0
   */
  addListener(
    eventName: 'complete',
    listenerFunc: (data: { url: string }) => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;
}

export interface PluginsConfig {
  /**
   * Klarna KCO can be configured with the following options:
   */
  KlarnaKco?: {
    /**
     * Configure the return url for the iOS.
     *
     * @since 1.0.0
     * @default ""
     * @example "app-return-url://"
     */
    iosReturnUrl?: string;

    /**
     * Set true if willing to send GET request to confirm url when checkout is completed.
     * This requires you to handle checkout view redirect to completed page in js.
     *
     * @since 1.0.0
     * @default false
     * @example false
     */
    handleConfirmation?: boolean;

    /**
     * Set true if willing to handle validation errors in your application
     *
     * @since 1.0.0
     * @default false
     * @example false
     */
    handleValidationErrors?: boolean;

    /**
     * Set true if willing to handle validation errors in your application
     *
     * @since 1.0.0
     * @default #ffffff
     * @example false
     */
    barColor?: string;

    /**
     * Set true if willing to handle validation errors in your application
     *
     * @since 1.0.0
     * @default #ff3b30
     * @example false
     */
    baritemColor?: string;
  };
}

export interface KlarnaLoggingLevel {
  /**
   * Configure the Klarna SDK logging level.
   *
   * @since 1.0.0
   * @default native
   * @example "verbose"
   */
  value: 'off' | 'error' | 'verbose';
}
