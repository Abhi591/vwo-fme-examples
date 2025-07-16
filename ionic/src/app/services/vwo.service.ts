/**
 * Copyright 2025 Wingify Software Pvt. Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { Injectable } from '@angular/core';
import { BehaviorSubject, Observable } from 'rxjs';
import { init } from 'vwo-fme-node-sdk';
import { environment } from '../../environments/environment';

export interface VWOContext {
  id: string;
  customVariables?: any;
  userAgent?: string;
  ipAddress?: string;
}

export interface FlagResult {
  isEnabled(): boolean;
  getVariable(key: string, defaultValue: any): any;
}

export interface VWOLog {
  timestamp: string;
  level: string;
  message: string;
}

@Injectable({
  providedIn: 'root'
})
export class VwoService {
  private vwoClient: any = null;
  private isInitializedSubject = new BehaviorSubject<boolean>(false);
  private errorSubject = new BehaviorSubject<string | null>(null);
  private logsSubject = new BehaviorSubject<VWOLog[]>([]);
  
  public isInitialized$ = this.isInitializedSubject.asObservable();
  public error$ = this.errorSubject.asObservable();
  public logs$ = this.logsSubject.asObservable();

  constructor() {
    this.initializeVWO();
  }

  private async initializeVWO(): Promise<void> {
    try {
      // Debug logging to see what environment values are being used
      console.log('Environment values:', {
        accountId: environment.vwo.accountId,
        sdkKey: environment.vwo.sdkKey,
        flagKey: environment.vwo.flagKey
      });
      
      this.addLog('DEBUG', `Initializing VWO with Account ID: ${environment.vwo.accountId}`);
      this.addLog('DEBUG', `Using SDK Key: ${environment.vwo.sdkKey}`);
      
      const options = {
        accountId: environment.vwo.accountId,
        sdkKey: environment.vwo.sdkKey,
        logger: {
          level: 'DEBUG',
          transport: {
            level: 'DEBUG',
            log: (level: string, message: string) => {
              this.addLog(level, message);
            }
          }
        }
      };

      console.log('VWO initialization options:', options);
      this.addLog('DEBUG', `Calling VWO init with options: ${JSON.stringify(options)}`);

      this.vwoClient = await init(options);
      this.isInitializedSubject.next(true);
      this.addLog('INFO', 'VWO FME SDK initialized successfully');
    } catch (error: any) {
      console.error('Failed to initialize VWO SDK:', error);
      this.errorSubject.next(error.message || 'Failed to initialize VWO SDK');
      this.addLog('ERROR', `Failed to initialize VWO SDK: ${error.message}`);
    }
  }

  private addLog(level: string, message: string): void {
    const currentLogs = this.logsSubject.value;
    const newLog: VWOLog = {
      timestamp: new Date().toLocaleString(),
      level,
      message
    };
    
    const updatedLogs = [...currentLogs, newLog];
    // Keep only the last 100 logs
    if (updatedLogs.length > 100) {
      updatedLogs.splice(0, updatedLogs.length - 100);
    }
    
    this.logsSubject.next(updatedLogs);
  }

  public async getFlag(featureKey: string, context: VWOContext): Promise<FlagResult | null> {
    if (!this.vwoClient || !this.isInitializedSubject.value) {
      console.warn('VWO SDK not initialized');
      return null;
    }

    try {
      const flag = this.vwoClient.getFlag(featureKey, context);
      return flag;
    } catch (error: any) {
      console.error('Error getting feature flag:', error);
      this.addLog('ERROR', `Error getting feature flag: ${error.message}`);
      return null;
    }
  }

  public trackEvent(eventName: string, context: VWOContext, eventProperties?: any): void {
    if (!this.vwoClient || !this.isInitializedSubject.value) {
      console.warn('VWO SDK not initialized');
      return;
    }

    try {
      this.vwoClient.trackEvent(eventName, context, eventProperties);
      this.addLog('INFO', `Event tracked: ${eventName}`);
    } catch (error: any) {
      console.error('Error tracking event:', error);
      this.addLog('ERROR', `Error tracking event: ${error.message}`);
    }
  }

  public setAttribute(attributeKey: string, attributeValue: any, context: VWOContext): void {
    if (!this.vwoClient || !this.isInitializedSubject.value) {
      console.warn('VWO SDK not initialized');
      return;
    }

    try {
      this.vwoClient.setAttribute(attributeKey, attributeValue, context);
      this.addLog('INFO', `Attribute set: ${attributeKey}=${attributeValue}`);
    } catch (error: any) {
      console.error('Error setting attribute:', error);
      this.addLog('ERROR', `Error setting attribute: ${error.message}`);
    }
  }

  public get isInitialized(): boolean {
    return this.isInitializedSubject.value;
  }

  public get currentError(): string | null {
    return this.errorSubject.value;
  }

  public get currentLogs(): VWOLog[] {
    return this.logsSubject.value;
  }

  public clearLogs(): void {
    this.logsSubject.next([]);
  }
} 