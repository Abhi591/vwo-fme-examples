/*
 * Copyright (c) 2024-2025 Wingify Software Pvt. Ltd.
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 *
 */
package com.example.fmeexample.analytics

import android.content.Context
import com.segment.analytics.kotlin.android.Analytics
import com.segment.analytics.kotlin.core.*

class SegmentIntegration private constructor(context: Context, writeKey: String) {

    private val analytics: Analytics = Analytics(writeKey, context.applicationContext) {
        trackApplicationLifecycleEvents = true
        flushAt = 3
        flushInterval = 10
    }

    companion object {
        @Volatile
        private var instance: SegmentIntegration? = null

        fun getInstance(context: Context, writeKey: String): SegmentIntegration {
            return instance ?: synchronized(this) {
                instance ?: SegmentIntegration(context, writeKey).also { instance = it }
            }
        }
    }

    fun trackEvent(properties: Map<String, Any>) {
        val segmentProperties = properties.toMutableMap()
        analytics.track("vwo_fme_track_event", segmentProperties)
    }

    fun trackFlagEvaluation(properties: Map<String, Any>) {
        analytics.track("vwo_fme_flag_evaluation", properties)
    }

    fun identify(userId: String, traits: Map<String, Any> = emptyMap()) {
        analytics.identify(userId, traits)
    }

    fun flush() {
        analytics.flush()
    }
} 