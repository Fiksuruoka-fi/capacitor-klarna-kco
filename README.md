# @capacitor-community/klarna-kco

Klarna Checkout integration to Capacitor.js

## Installation

TODO

Sync native files:

```bash
npx cap sync
```

## Setup
Include configuration to `capacitor.config.json`
```json
{
  "plugins": {
    "KlarnaKco": {
      "returnUrlIos": "app-return-url://"
    }
  }
}
```

## Usage

```js
import { KlarnaKco } from "@capacitor-community/intercom";
```

## API

<docgen-index>

* [`viewDidLoad()`](#viewdidload)
* [`destroy()`](#destroy)
* [`deviceIdentifier()`](#deviceidentifier)
* [`setLoggingLevel(...)`](#setlogginglevel)
* [`addListener(...)`](#addlistener)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### viewDidLoad()

```typescript
viewDidLoad() => Promise<void>
```

--------------------


### destroy()

```typescript
destroy() => Promise<void>
```

--------------------


### deviceIdentifier()

```typescript
deviceIdentifier() => Promise<void>
```

--------------------


### setLoggingLevel(...)

```typescript
setLoggingLevel(options: { value: KlarnaLoggingLevel; }) => Promise<void>
```

| Param         | Type                                                                          |
| ------------- | ----------------------------------------------------------------------------- |
| **`options`** | <code>{ value: <a href="#klarnalogginglevel">KlarnaLoggingLevel</a>; }</code> |

--------------------


### addListener(...)

```typescript
addListener(eventName: 'complete', listenerFunc: (data: { url: string; }) => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the Klarna Checkout is complete.

| Param              | Type                                             |
| ------------------ | ------------------------------------------------ |
| **`eventName`**    | <code>"complete"</code>                          |
| **`listenerFunc`** | <code>(data: { url: string; }) =&gt; void</code> |

**Returns:** <code>any</code>

--------------------


### Interfaces


#### KlarnaLoggingLevel

| Prop        | Type                                       | Description                             |
| ----------- | ------------------------------------------ | --------------------------------------- |
| **`value`** | <code>"error" \| "off" \| "verbose"</code> | Configure the Klarna SDK logging level. |


#### PluginListenerHandle

| Prop         | Type                                      |
| ------------ | ----------------------------------------- |
| **`remove`** | <code>() =&gt; Promise&lt;void&gt;</code> |

</docgen-api>
