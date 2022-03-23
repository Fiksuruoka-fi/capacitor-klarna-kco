import type { PluginListenerHandle } from '@capacitor/core';

export interface KlarnaKcoPlugin {
  destroy(): Promise<void>;
  initialize(): Promise<void>;
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
     * @default native
     * @example "app-return-url://"
     */
    iosReturnUrl?: string;
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
