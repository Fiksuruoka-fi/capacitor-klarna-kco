# @capacitor-community/klarna-kco

Klarna Checkout integration to Capacitor.js

## Installation

Using npm:

```bash
npm install @capacitor-community/intercom
```

Using yarn:

```bash
yarn add @capacitor-community/intercom
```

Sync native files:

```bash
npx cap sync
```

## Setup
Include configuration to `capacitor.config.json`
```json
{
  plugins: {
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

* [`echo(...)`](#echo)
* [`deviceIdentifier()`](#deviceidentifier)
* [`setLoggingLevel(...)`](#setlogginglevel)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [`addListener(...)`](#addlistener)
* [Interfaces](#interfaces)

</docgen-index>

<docgen-api>
<!--Update the source file JSDoc comments and rerun docgen to update the docs below-->

### echo(...)

```typescript
echo(options: { value: string; }) => any
```

| Param         | Type                            |
| ------------- | ------------------------------- |
| **`options`** | <code>{ value: string; }</code> |

**Returns:** <code>any</code>

--------------------


### deviceIdentifier()

```typescript
deviceIdentifier() => any
```

**Returns:** <code>any</code>

--------------------


### setLoggingLevel(...)

```typescript
setLoggingLevel(options: { value: KlarnaLoggingLevel; }) => any
```

| Param         | Type                                                                          |
| ------------- | ----------------------------------------------------------------------------- |
| **`options`** | <code>{ value: <a href="#klarnalogginglevel">KlarnaLoggingLevel</a>; }</code> |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'klarnaWillShowFullscreen', listenerFunc: () => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the Klarna fullscreen view is about to be shown.

| Param              | Type                                    |
| ------------------ | --------------------------------------- |
| **`eventName`**    | <code>"klarnaWillShowFullscreen"</code> |
| **`listenerFunc`** | <code>() =&gt; void</code>              |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'klarnaDidShowFullscreen', listenerFunc: () => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the Klarna fullscreen view is shown.

| Param              | Type                                   |
| ------------------ | -------------------------------------- |
| **`eventName`**    | <code>"klarnaDidShowFullscreen"</code> |
| **`listenerFunc`** | <code>() =&gt; void</code>             |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'klarnaWillHideFullscreen', listenerFunc: () => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the Klarna fullscreen view is about to hide.

| Param              | Type                                    |
| ------------------ | --------------------------------------- |
| **`eventName`**    | <code>"klarnaWillHideFullscreen"</code> |
| **`listenerFunc`** | <code>() =&gt; void</code>              |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'klarnaDidHideFullscreen', listenerFunc: () => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the Klarna fullscreen view is hidden.

| Param              | Type                                   |
| ------------------ | -------------------------------------- |
| **`eventName`**    | <code>"klarnaDidHideFullscreen"</code> |
| **`listenerFunc`** | <code>() =&gt; void</code>             |

**Returns:** <code>any</code>

--------------------


### addListener(...)

```typescript
addListener(eventName: 'klarnaFailed', listenerFunc: () => void) => Promise<PluginListenerHandle> & PluginListenerHandle
```

Listen for when the Klarna fails.

| Param              | Type                        |
| ------------------ | --------------------------- |
| **`eventName`**    | <code>"klarnaFailed"</code> |
| **`listenerFunc`** | <code>() =&gt; void</code>  |

**Returns:** <code>any</code>

--------------------


### Interfaces


#### KlarnaLoggingLevel

| Prop        | Type                                       | Description                             |
| ----------- | ------------------------------------------ | --------------------------------------- |
| **`value`** | <code>"error" \| "off" \| "verbose"</code> | Configure the Klarna SDK logging level. |


#### PluginListenerHandle

| Prop         | Type                      |
| ------------ | ------------------------- |
| **`remove`** | <code>() =&gt; any</code> |

</docgen-api>
