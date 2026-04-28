/**
 * Copyright 2025 Wingify Software Pvt. Ltd.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package config

import (
	"encoding/json"
	"fmt"
	"os"
	"strconv"
)

// VWOConfig holds VWO SDK configuration
type VWOConfig struct {
	AccountID      string
	SDKKey         string
	FlagKey        string
	EventName      string
	CustomVariables map[string]interface{}
	Attributes     map[string]interface{}
	LogLevel       string
	PollInterval   int
	VariableKey1   string
	VariableKey2   string
}

// Config holds the application configuration
type Config struct {
	VWO VWOConfig
}

var appConfig *Config

// LoadConfig loads configuration from environment  variables
func LoadConfig() (*Config, error) {
	if appConfig != nil {
		return appConfig, nil
	}

	accountID := os.Getenv("VWO_ACCOUNT_ID")
	if accountID == "" {
		accountID = "0"
	}

	sdkKey := os.Getenv("VWO_SDK_KEY")
	flagKey := os.Getenv("VWO_FLAG_KEY")
	eventName := os.Getenv("VWO_EVENT_NAME")
	logLevel := os.Getenv("VWO_LOG_LEVEL")
	if logLevel == "" {
		logLevel = "DEBUG"
	}

	pollIntervalStr := os.Getenv("VWO_POLLING_INTERVAL")
	if pollIntervalStr == "" {
		pollIntervalStr = "5000"
	}
	pollInterval, err := strconv.Atoi(pollIntervalStr)
	if err != nil {
		pollInterval = 5000
	}

	variableKey1 := os.Getenv("VWO_FLAG_VARIABLE_1_KEY")
	if variableKey1 == "" {
		variableKey1 = "model_name"
	}

	variableKey2 := os.Getenv("VWO_FLAG_VARIABLE_2_KEY")
	if variableKey2 == "" {
		variableKey2 = "query_answer"
	}

	var customVariables map[string]interface{}
	customVarsStr := os.Getenv("VWO_CUSTOM_VARIABLES")
	if customVarsStr != "" {
		if err := json.Unmarshal([]byte(customVarsStr), &customVariables); err != nil {
			customVariables = make(map[string]interface{})
		}
	} else {
		customVariables = make(map[string]interface{})
	}

	var attributes map[string]interface{}
	attributesStr := os.Getenv("VWO_USER_ATTRIBUTES")
	if attributesStr != "" {
		if err := json.Unmarshal([]byte(attributesStr), &attributes); err != nil {
			attributes = make(map[string]interface{})
		}
	} else {
		attributes = make(map[string]interface{})
	}

	appConfig = &Config{
		VWO: VWOConfig{
			AccountID:       accountID,
			SDKKey:          sdkKey,
			FlagKey:         flagKey,
			EventName:       eventName,
			CustomVariables: customVariables,
			Attributes:      attributes,
			LogLevel:        logLevel,
			PollInterval:    pollInterval,
			VariableKey1:    variableKey1,
			VariableKey2:    variableKey2,
		},
	}

	// Validate required configuration
	if appConfig.VWO.AccountID == "" || appConfig.VWO.AccountID == "0" {
		return nil, fmt.Errorf("missing required configuration: VWO_ACCOUNT_ID")
	}
	if appConfig.VWO.SDKKey == "" {
		return nil, fmt.Errorf("missing required configuration: VWO_SDK_KEY")
	}
	if appConfig.VWO.FlagKey == "" {
		return nil, fmt.Errorf("missing required configuration: VWO_FLAG_KEY")
	}

	return appConfig, nil
}

// GetConfig returns the loaded configuration
func GetConfig() *Config {
	return appConfig
}

