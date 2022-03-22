import { WebPlugin } from '@capacitor/core';
export class KlarnaKcoWeb extends WebPlugin {
    async viewDidLoad() {
        throw this.unimplemented('Not implemented on web.');
    }
    async destroy() {
        throw this.unimplemented('Not implemented on web.');
    }
    async deviceIdentifier() {
        throw this.unimplemented('Not implemented on web.');
    }
    async setLoggingLevel(_options) {
        throw this.unimplemented('Not implemented on web.');
    }
}
//# sourceMappingURL=web.js.map