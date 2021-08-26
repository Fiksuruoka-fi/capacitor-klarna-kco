import { registerPlugin } from '@capacitor/core';
const KlarnaKco = registerPlugin('KlarnaKco', {
    web: () => import('./web').then(m => new m.KlarnaKcoWeb()),
});
export * from './definitions';
export { KlarnaKco };
//# sourceMappingURL=index.js.map