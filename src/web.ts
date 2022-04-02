import { WebPlugin } from '@capacitor/core';

import type { KlarnaKcoPlugin } from './definitions';

export class KlarnaKcoWeb extends WebPlugin implements KlarnaKcoPlugin {
  async alert(_options: { title: string; message: string }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async destroy(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async initialize(_options: {
    checkoutUrl?: string;
    snippet?: string;
  }): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async loaded(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async resume(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async suspend(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }
}
