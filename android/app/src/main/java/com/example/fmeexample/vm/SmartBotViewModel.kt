/*
 * Copyright (c) 2025 Wingify Software Pvt. Ltd.
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
package com.example.fmeexample.vm

import android.content.Context
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.fmeexample.BuildConfig
import com.example.fmeexample.analytics.MixpanelIntegration
import com.example.fmeexample.analytics.SegmentIntegration
import com.example.fmeexample.fme.FmeHelper
import com.example.fmeexample.models.ChatResponse
import com.example.fmeexample.models.UserInfo
import com.example.fmeexample.useCases.SendChatQueryUseCaseImpl
import com.vwo.interfaces.integration.IntegrationCallback
import kotlinx.coroutines.launch

class SmartBotViewModel(private val chatQueryUseCase: SendChatQueryUseCaseImpl) : ViewModel() {
    private val _chatResponse = MutableLiveData<ChatResponse>()
    val chatResponse: LiveData<ChatResponse> = _chatResponse

    private val _userInfo = MutableLiveData<UserInfo>()
    val userInfo: LiveData<UserInfo> = _userInfo

    private var mixpanelIntegration: MixpanelIntegration? = null
    private var segmentIntegration: SegmentIntegration? = null

    suspend fun init(context: Context) {
        loadInitialData()
        initFme(context, createAnalyticsIntegration(context))
    }

    private fun createAnalyticsIntegration(context: Context): IntegrationCallback? {
        val mixpanelToken = BuildConfig.MIXPANEL_PROJECT_TOKEN
        val segmentWriteKey = BuildConfig.SEGMENT_WRITE_KEY

        if (mixpanelToken.isEmpty() && segmentWriteKey.isEmpty()) {
            return null
        }

        initializeMixpanel(context, mixpanelToken)
        initializeSegment(context, segmentWriteKey)

        return object : IntegrationCallback {
            override fun execute(properties: Map<String, Any>) {
                handleEventTracking(properties)
                handleFlagEvaluation(properties)
            }
        }
    }

    private fun initializeMixpanel(context: Context, token: String) {
        if (token.isNotEmpty()) {
            mixpanelIntegration = MixpanelIntegration.getInstance(context, token)
        }
    }

    private fun initializeSegment(context: Context, writeKey: String) {
        if (writeKey.isNotEmpty()) {
            segmentIntegration = SegmentIntegration.getInstance(context, writeKey)
        }
    }

    private fun handleEventTracking(properties: Map<String, Any>) {
        if (properties["api"] == "track") {
            val eventName = properties["eventName"] as String
            mixpanelIntegration?.trackEvent(eventName, properties)
            segmentIntegration?.trackEvent(properties)
        }
    }

    private fun handleFlagEvaluation(properties: Map<String, Any>) {
        if (properties.containsKey("featureName")) {
            mixpanelIntegration?.trackFlagEvaluation(properties)
            segmentIntegration?.trackFlagEvaluation(properties)

            // Identify user in Segment
            val userId = properties["userId"] as? String
            if (!userId.isNullOrEmpty()) {
                segmentIntegration?.identify(userId, mapOf(
                    "featureName" to (properties["featureName"] ?: ""),
                    "variationId" to (properties["experimentVariationId"] ?: "")
                ))
            }
        }
    }

    private fun loadInitialData() {
        viewModelScope.launch {
            _userInfo.value = UserInfo("", "")
        }
    }

    fun sendQuery(userId: String, query: String) {
        viewModelScope.launch {
            processUserQuery(userId, query)
        }
    }

    fun getUserId() {
        viewModelScope.launch {
            _userInfo.postValue(UserInfo(generateRandomUserId(), generateRandomQuery()))
        }
    }

    private fun generateRandomUserId(): String {
        val letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return (1..12)
            .map { letters.random() }
            .joinToString("")
    }

    private fun generateRandomQuery(): String {
        return "I forgot my password"
    }

    private suspend fun initFme(context: Context, integrations: IntegrationCallback?) {
        FmeHelper.initFME(context, integrations)
    }

    private suspend fun processUserQuery(userId: String, query: String) {
        val chatResponse = chatQueryUseCase.getChatResponse(userId, query)
        if (chatResponse != null) {
            _chatResponse.postValue(chatResponse)
        }
    }

    fun sendEvent(userId: String) {
        chatQueryUseCase.sendEvent(userId)
    }
}
