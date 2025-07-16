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

import { Component, OnInit, OnDestroy } from '@angular/core';
import { CommonModule } from '@angular/common';
import { FormsModule } from '@angular/forms';
import { IonicModule } from '@ionic/angular';
import { Router } from '@angular/router';
import { VwoService, VWOContext, FlagResult, VWOLog } from '../services/vwo.service';
import { environment } from '../../environments/environment';
import { Subscription } from 'rxjs';

@Component({
  selector: 'app-smart-bot',
  templateUrl: './smart-bot.page.html',
  styleUrls: ['./smart-bot.page.scss'],
  standalone: true,
  imports: [CommonModule, FormsModule, IonicModule]
})
export class SmartBotPage implements OnInit, OnDestroy {
  userId: string = '';
  messageText: string = '';
  isLoading: boolean = false;
  isFeatureEnabled: boolean = false;
  userQueries: string[] = [];
  featureModelName: string = '';
  featureBackground: string = '#ffffff';
  featureContent: string = '';
  
  // VWO related properties
  isVwoInitialized: boolean = false;
  vwoError: string | null = null;
  vwoLogs: VWOLog[] = [];
  
  private subscriptions: Subscription[] = [];

  private readonly defaultBotResponse = `
To reset your password:
1. Open the app and go to the login screen.
2. Tap 'Forgot Password?' below the password field.
3. Enter your registered email address and submit.
4. Check your inbox for a password reset email (it may take a few minutes).
5. Click the link in the email and follow the instructions to create a new password.
6. Return to the app and log in with your new password.
  `;

  constructor(private vwoService: VwoService, private router: Router) { }

  ngOnInit() {
    // Subscribe to VWO initialization status
    this.subscriptions.push(
      this.vwoService.isInitialized$.subscribe(isInitialized => {
        this.isVwoInitialized = isInitialized;
      })
    );

    // Subscribe to VWO errors
    this.subscriptions.push(
      this.vwoService.error$.subscribe(error => {
        this.vwoError = error;
      })
    );

    // Subscribe to VWO logs
    this.subscriptions.push(
      this.vwoService.logs$.subscribe(logs => {
        this.vwoLogs = logs;
      })
    );

    // Leave message text empty so users can type freely
    this.messageText = '';
  }

  ngOnDestroy() {
    // Unsubscribe from all subscriptions
    this.subscriptions.forEach(sub => sub.unsubscribe());
  }

  generateRandomUserId(): string {
    const letters = 'abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    let userId = '';
    for (let i = 0; i < 12; i++) {
      const randomIndex = Math.floor(Math.random() * letters.length);
      userId += letters[randomIndex];
    }
    return userId;
  }

  onAssignClick(): void {
    if (!this.isLoading) {
      this.userId = this.generateRandomUserId();
      this.messageText = "I forgot my password";
    }
  }

  async onSendClick(): Promise<void> {
    // Validation check for empty fields
    if (!this.userId || !this.messageText.trim()) {
      alert('Missing Information\n\nPlease enter both User ID and Query.');
      return;
    }

    if (!this.isLoading && this.messageText && this.isVwoInitialized && this.userId) {
      this.isLoading = true;
      const query = this.messageText;
      this.userQueries = [...this.userQueries, this.messageText];

      const context: VWOContext = {
        id: this.userId,
        customVariables: {},
      };

      try {
        // Get the feature flag
        const flagResult: FlagResult | null = await this.vwoService.getFlag(
          environment.vwo.flagKey, 
          context
        );

        if (flagResult) {
          // Check if feature is enabled
          const flagEnabled = flagResult.isEnabled();
          this.isFeatureEnabled = flagEnabled;

          if (flagEnabled) {
            // Get model name variable
            const modelName = flagResult.getVariable(
              environment.vwo.variables.modelName, 
              'GPT-4'
            );
            this.featureModelName = modelName;

            // Get query answer variable (JSON)
            const queryAnswer = flagResult.getVariable(
              environment.vwo.variables.queryAnswer, 
              { background: '#ffffff', content: this.defaultBotResponse }
            );

            this.featureBackground = queryAnswer.background || '#ffffff';
            this.featureContent = queryAnswer.content || this.defaultBotResponse;

            // Track the event
            const eventProperties = {
              model: modelName,
              query: query,
              response: this.featureContent,
            };

            this.vwoService.trackEvent(
              environment.vwo.events.aiModelInteracted, 
              context, 
              eventProperties
            );
          } else {
            // Set default values
            this.featureBackground = '#ffffff';
            this.featureModelName = '';
            this.featureContent = this.defaultBotResponse;
          }
        } else {
          // Fallback if flag retrieval fails
          this.isFeatureEnabled = false;
          this.featureBackground = '#ffffff';
          this.featureModelName = '';
          this.featureContent = this.defaultBotResponse;
        }
      } catch (error) {
        console.error('Error handling send:', error);
        // Set fallback values
        this.isFeatureEnabled = false;
        this.featureBackground = '#ffffff';
        this.featureModelName = '';
        this.featureContent = this.defaultBotResponse;
      } finally {
        this.isLoading = false;
      }
    }
  }



  openLogs(): void {
    this.router.navigate(['/logs']);
  }

  getDisplayUserId(): string {
    return this.userId.length > 8 ? `${this.userId.substring(0, 8)}...` : this.userId;
  }

  trackByLog(index: number, log: VWOLog): string {
    return `${log.timestamp}-${log.level}-${index}`;
  }
} 