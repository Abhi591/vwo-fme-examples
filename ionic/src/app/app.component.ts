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

import { Component, OnInit } from '@angular/core';
import { IonApp, IonRouterOutlet } from '@ionic/angular/standalone';
import { StatusBar, Style } from '@capacitor/status-bar';
import { Platform } from '@ionic/angular';

@Component({
  selector: 'app-root',
  templateUrl: 'app.component.html',
  imports: [IonApp, IonRouterOutlet],
})
export class AppComponent implements OnInit {
  constructor(private platform: Platform) {}

  async ngOnInit() {
    // Configure status bar for Android with better handling
    if (this.platform.is('capacitor')) {
      try {
        // Set dark content style (dark icons on light background)
        await StatusBar.setStyle({ style: Style.Light });
        
        // Set white background for status bar
        await StatusBar.setBackgroundColor({ color: '#ffffff' });
        
        // Don't overlay the web view - this prevents content overlap
        await StatusBar.setOverlaysWebView({ overlay: false });
        
        // Show the status bar
        await StatusBar.show();
        
        console.log('Status bar configured successfully');
      } catch (error) {
        console.log('Status bar configuration error:', error);
      }
    }
  }
}
