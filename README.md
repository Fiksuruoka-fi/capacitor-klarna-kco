# Capacitor Klarna Checkout
Klarna Checkout integration to Capacitor.js for loading Checkout widget inside Capacitor app.

## Installation
```bash
yarn add @foodello/capacitor-klarna-kco

or

npm install @foodello/capacitor-klarna-kco
```

Then run

```bash
npx cap sync
```

---

## Setup
**Reguired:** Include configuration to `capacitor.config.json`

```json
{
  "plugins": {
    "KlarnaKco": {
      "returnUrlIos": "your-app-scheme://",
      "returnUrlAndroid": "your-app-scheme://",
      "handleValidationErrors": false
    }
  }
}
```

### Android modifications

1. Edit your application level build.gradle file and add the following repository to your repositories section:
   ```gradle
   repositories {
     ....
     maven {
         url 'https://x.klarnacdn.net/mobile-sdk/'
     }
   }
   ```
2. If you are willing to change SDK version, add new version to your variables.gradle
   ```gradle
   ext {
     ...
     klarnaSdkVersion: 'x.x.x'
   }
   ```
   Default is `1.7.1`
3. Check that your main activity has intent filter and it supports return URL defined in `capacitor.config.json`. `AndroidManifest.xml`:
   ```xml
   <intent-filter>
     <action android:name="android.intent.action.VIEW" />
     <category android:name="android.intent.category.DEFAULT" />
     <category android:name="android.intent.category.BROWSABLE" />
     <data android:scheme="<your-app-scheme>" />
     <data android:host="<your-app-host>" />
   </intent-filter>
   ```

**Note:**
The hosting Activity should be using launchMode of singleTask or singleTop to prevent a new instance from being created when returning from an external application. This should be `singleTask` if you have not modified this by yourself.

```xml
<activity android:launchMode="singleTask|singleTop">
```

---

## Usage
Import plugin to your application
```js
import { KlarnaKco } from "@capacitor-community/klarna-kco";
```

Remember to attach listeners to the events you are willing to handle. For example in order to perform navigation inside your application, listen `complete` -event:
```js
KlarnaKco.addListener('complete', ({ url }) => {/* PERFORM NAVIGATION */})
```

---

## Check Klarna's documentation for more information
https://docs.klarna.com/in-app/checkout-sdk/

---

## API
<docgen-index>

* [`destroy()`](#destroy)
* [`resume()`](#resume)
* [`suspend()`](#suspend)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### destroy()

```typescript
destroy() => Promise<void>
```

Destroy Klarna SDK

--------------------


### resume()

```typescript
resume() => Promise<void>
```

Resume interactions on Klarna Checkout widget

--------------------


### suspend()

```typescript
suspend() => Promise<void>
```

Suspend interactions on Klarna Checkout widget

--------------------


### addListener(...)

```typescript
addListener(eventName: 'complete', listenerFunc: (data: { url: string; }) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the payment created.

| Param              | Type                                             |
| ------------------ | ------------------------------------------------ |
| **`eventName`**    | <code>"complete"</code>                          |
| **`listenerFunc`** | <code>(data: { url: string; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'load', listenerFunc: (data: EventData['load']) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the KCO iframe has been created successfully.

| Param              | Type                                                                                                                          |
| ------------------ | ----------------------------------------------------------------------------------------------------------------------------- |
| **`eventName`**    | <code>"load"</code>                                                                                                           |
| **`listenerFunc`** | <code>(data: { customer: { type: string; }; shipping_address: { country: string; postal_code: string; }; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'user_interacted', listenerFunc: (data: EventData['user_interacted']) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the user has interacted with the KCO iframe.

| Param              | Type                                              |
| ------------------ | ------------------------------------------------- |
| **`eventName`**    | <code>"user_interacted"</code>                    |
| **`listenerFunc`** | <code>(data: { type: string; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'customer', listenerFunc: (data: EventData['customer']) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the user has interacted with the KCO iframe.

| Param              | Type                                              |
| ------------------ | ------------------------------------------------- |
| **`eventName`**    | <code>"customer"</code>                           |
| **`listenerFunc`** | <code>(data: { type: string; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'change', listenerFunc: (data: EventData['change']) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when organization type (B2B or Person) was changed.

| Param              | Type                                                                                     |
| ------------------ | ---------------------------------------------------------------------------------------- |
| **`eventName`**    | <code>"change"</code>                                                                    |
| **`listenerFunc`** | <code>(data: { email: string; postal_code: string; country: string; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'billing_address_change', listenerFunc: (data: EventData['billing_address_change']) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when postal code, country or email was changed.

| Param              | Type                                                                      |
| ------------------ | ------------------------------------------------------------------------- |
| **`eventName`**    | <code>"billing_address_change"</code>                                     |
| **`listenerFunc`** | <code>(data: { postal_code: string; country: string; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'shipping_address_change', listenerFunc: (data: EventData['shipping_address_change']) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when shipping address was submitted.

| Param              | Type                                                                      |
| ------------------ | ------------------------------------------------------------------------- |
| **`eventName`**    | <code>"shipping_address_change"</code>                                    |
| **`listenerFunc`** | <code>(data: { postal_code: string; country: string; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'shipping_option_changed', listenerFunc: (data: EventData['shipping_option_changed']) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the user has selected a new shipping option.

| Param              | Type                                                                                                                                                   |
| ------------------ | ------------------------------------------------------------------------------------------------------------------------------------------------------ |
| **`eventName`**    | <code>"shipping_option_changed"</code>                                                                                                                 |
| **`listenerFunc`** | <code>(data: { description: string; id: string; name: string; price: number; promo: string; tax_amount: number; tax_rate: number; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'order_total_change', listenerFunc: (data: EventData['order_total_change']) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when we got changes on the cart from the merchant.

| Param              | Type                                                     |
| ------------------ | -------------------------------------------------------- |
| **`eventName`**    | <code>"order_total_change"</code>                        |
| **`listenerFunc`** | <code>(data: { order_total: number; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'checkbox_change', listenerFunc: (data: EventData['checkbox_change']) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when a checkbox was checked/unchecked.

| Param              | Type                                                               |
| ------------------ | ------------------------------------------------------------------ |
| **`eventName`**    | <code>"checkbox_change"</code>                                     |
| **`listenerFunc`** | <code>(data: { key: string; checked: boolean; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'network_error', listenerFunc: (data: EventData['network_error']) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for network error in KCO iframe.

| Param              | Type                               |
| ------------------ | ---------------------------------- |
| **`eventName`**    | <code>"network_error"</code>       |
| **`listenerFunc`** | <code>(data: {}) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'redirect_initiated', listenerFunc: (data: EventData['redirect_initiated']) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the user is about to be redirected to the confirmation page.

| Param              | Type                                 |
| ------------------ | ------------------------------------ |
| **`eventName`**    | <code>"redirect_initiated"</code>    |
| **`listenerFunc`** | <code>(data: true) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'load_confirmation', listenerFunc: (data: EventData['load_confirmation']) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the confirmation iframe has been created succesfully.

| Param              | Type                               |
| ------------------ | ---------------------------------- |
| **`eventName`**    | <code>"load_confirmation"</code>   |
| **`listenerFunc`** | <code>(data: {}) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### Interfaces


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |


#### EventData

| Prop                                | Type                                                                                                                                |
| ----------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------- |
| **`load`**                          | <code>{ customer: { type: string; }; shipping_address: { country: string; postal_code: string; }; }</code>                          |
| **`user_interacted`**               | <code>{ type: string; }</code>                                                                                                      |
| **`customer`**                      | <code>{ type: string; }</code>                                                                                                      |
| **`change`**                        | <code>{ email: string; postal_code: string; country: string; }</code>                                                               |
| **`billing_address_change`**        | <code>{ postal_code: string; country: string; }</code>                                                                              |
| **`shipping_address_change`**       | <code>{ postal_code: string; country: string; }</code>                                                                              |
| **`shipping_option_changed`**       | <code>{ description: string; id: string; name: string; price: number; promo: string; tax_amount: number; tax_rate: number; }</code> |
| **`shipping_address_update_error`** | <code>{}</code>                                                                                                                     |
| **`order_total_change`**            | <code>{ order_total: number; }</code>                                                                                               |
| **`checkbox_change`**               | <code>{ key: string; checked: boolean; }</code>                                                                                     |
| **`network_error`**                 | <code>{}</code>                                                                                                                     |
| **`redirect_initiated`**            | <code>true</code>                                                                                                                   |
| **`load_confirmation`**             | <code>{}</code>                                                                                                                     |

</docgen-api>
