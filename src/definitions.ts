import type { PluginListenerHandle } from '@capacitor/core';

export interface KlarnaKcoPlugin {
  viewDidLoad(): Promise<void>;
  deviceIdentifier(): Promise<void>;
  setLoggingLevel(options: { value: KlarnaLoggingLevel }): Promise<void>;

  /**
   * Listen for when the Klarna fullscreen view is about to be shown.
   *
   * @since 1.0.0
   */
  addListener(
    eventName: 'klarnaWillShowFullscreen',
    listenerFunc: () => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the Klarna fullscreen view is shown.
   *
   * @since 1.0.0
   */
  addListener(
    eventName: 'klarnaDidShowFullscreen',
    listenerFunc: () => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the Klarna fullscreen view is about to hide.
   *
   * @since 1.0.0
   */
  addListener(
    eventName: 'klarnaWillHideFullscreen',
    listenerFunc: () => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the Klarna fullscreen view is hidden.
   *
   * @since 1.0.0
   */
  addListener(
    eventName: 'klarnaDidHideFullscreen',
    listenerFunc: () => void,
  ): Promise<PluginListenerHandle> & PluginListenerHandle;

  /**
   * Listen for when the Klarna fails.
   *
   * @since 1.0.0
   */
  addListener(
    eventName: 'klarnaFailed',
    listenerFunc: () => void,
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
