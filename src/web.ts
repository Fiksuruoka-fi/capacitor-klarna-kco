import { WebPlugin } from '@capacitor/core';

import type { KlarnaKcoPlugin, KlarnaLoggingLevel } from './definitions';

export class KlarnaKcoWeb extends WebPlugin implements KlarnaKcoPlugin {
  async echo(options: { value: string }): Promise<{ value: string }> {
    console.log('ECHO', options);
    return options;
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
