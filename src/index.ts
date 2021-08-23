import { registerPlugin } from '@capacitor/core';

import type { KlarnaKcoPlugin } from './definitions';

const KlarnaKco = registerPlugin<KlarnaKcoPlugin>('KlarnaKco', {
  web: () => import('./web').then(m => new m.KlarnaKcoWeb()),
});

export * from './definitions';
export { KlarnaKco };
