import { WebPlugin } from '@capacitor/core';
export class KlarnaKcoWeb extends WebPlugin {
    async echo(options) {
        console.log('ECHO', options);
        return options;
    }
    async deviceIdentifier() {
        throw this.unimplemented('Not implemented on web.');
    }
    async setLoggingLevel(_options) {
        throw this.unimplemented('Not implemented on web.');
    }
}
//# sourceMappingURL=web.js.map