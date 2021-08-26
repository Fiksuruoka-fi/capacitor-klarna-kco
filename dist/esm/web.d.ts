import { WebPlugin } from '@capacitor/core';
import type { KlarnaKcoPlugin, KlarnaLoggingLevel } from './definitions';
export declare class KlarnaKcoWeb extends WebPlugin implements KlarnaKcoPlugin {
    echo(options: {
        value: string;
    }): Promise<{
        value: string;
    }>;
    deviceIdentifier(): Promise<void>;
    setLoggingLevel(_options: {
        value: KlarnaLoggingLevel;
    }): Promise<void>;
}
