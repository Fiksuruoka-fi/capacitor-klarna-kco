import { WebPlugin } from '@capacitor/core';

import type {
  KlarnaKcoPlugin,
  SetSnippetOptions,
  CallResult,
  KlarnaCallResult,
} from './definitions';

export class KlarnaKcoWeb extends WebPlugin implements KlarnaKcoPlugin {
  async initialize(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async setSnippet(_options: SetSnippetOptions): Promise<CallResult> {
    throw this.unimplemented('Not implemented on web.');
  }

  async open(): Promise<CallResult> {
    throw this.unimplemented('Not implemented on web.');
  }

  async close(): Promise<CallResult> {
    throw this.unimplemented('Not implemented on web.');
  }

  async destroy(): Promise<void> {
    throw this.unimplemented('Not implemented on web.');
  }

  async resume(): Promise<KlarnaCallResult> {
    throw this.unimplemented('Not implemented on web.');
  }

  async suspend(): Promise<KlarnaCallResult> {
    throw this.unimplemented('Not implemented on web.');
  }
}
