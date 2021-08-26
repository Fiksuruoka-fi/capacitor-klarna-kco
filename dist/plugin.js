var capacitorKlarnaKco = (function (exports, core) {
    'use strict';

    const KlarnaKco = core.registerPlugin('KlarnaKco', {
        web: () => Promise.resolve().then(function () { return web; }).then(m => new m.KlarnaKcoWeb()),
    });

    class KlarnaKcoWeb extends core.WebPlugin {
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

    var web = /*#__PURE__*/Object.freeze({
        __proto__: null,
        KlarnaKcoWeb: KlarnaKcoWeb
    });

    exports.KlarnaKco = KlarnaKco;

    Object.defineProperty(exports, '__esModule', { value: true });

    return exports;

}({}, capacitorExports));
//# sourceMappingURL=plugin.js.map
