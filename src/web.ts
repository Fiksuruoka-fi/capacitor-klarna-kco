import { WebPlugin } from '@capacitor/core';

import type { KlarnaKcoPlugin, KlarnaLoggingLevel } from './definitions';

export class KlarnaKcoWeb extends WebPlugin implements KlarnaKcoPlugin {
  async viewDidLoad(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async destroy(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async deviceIdentifier(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async setLoggingLevel(_options: {
    value: KlarnaLoggingLevel;
  }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
