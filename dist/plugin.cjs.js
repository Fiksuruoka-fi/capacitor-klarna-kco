'use strict';

Object.defineProperty(exports, '__esModule', { value: true });

var core = require('@capacitor/core');

const KlarnaKco = core.registerPlugin('KlarnaKco', {
    web: () => Promise.resolve().then(function () { return web; }).then(m => new m.KlarnaKcoWeb()),
});

class KlarnaKcoWeb extends core.WebPlugin {
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

var web = /*#__PURE__*/Object.freeze({
    __proto__: null,
    KlarnaKcoWeb: KlarnaKcoWeb
});

exports.KlarnaKco = KlarnaKco;
//# sourceMappingURL=plugin.cjs.js.map
