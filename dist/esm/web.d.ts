import { WebPlugin } from '@capacitor/core';
import type { KlarnaKcoPlugin, KlarnaLoggingLevel } from './definitions';
export declare class KlarnaKcoWeb extends WebPlugin implements KlarnaKcoPlugin {
    viewDidLoad(): Promise<void>;
    destroy(): Promise<void>;
    deviceIdentifier(): Promise<void>;
    setLoggingLevel(_options: {
        value: KlarnaLoggingLevel;
    }): Promise<void>;
}
