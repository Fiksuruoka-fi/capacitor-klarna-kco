import { WebPlugin } from '@capacitor/core';

import type { KlarnaKcoPlugin } from './definitions';

export class KlarnaKcoWeb extends WebPlugin implements KlarnaKcoPlugin {
  async destroy(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async resume(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async suspend(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
