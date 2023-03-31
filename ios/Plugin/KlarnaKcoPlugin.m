#import <Foundation/Foundation.h>
#import <Capacitor/Capacitor.h>

// Define the plugin using the CAP_PLUGIN Macro, and
// each method the plugin supports using the CAP_PLUGIN_METHOD macro.
CAP_PLUGIN(KlarnaKcoPlugin, "KlarnaKco",
           CAP_PLUGIN_METHOD(removeAllListeners, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(resume, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(suspend, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(initialize, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(open, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(close, CAPPluginReturnPromise);
           CAP_PLUGIN_METHOD(setSnippet, CAPPluginReturnNone);
           CAP_PLUGIN_METHOD(destroy, CAPPluginReturnNone);
)
