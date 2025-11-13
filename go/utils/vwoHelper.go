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

package utils

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"
	"sync"

	"github.com/wingify/vwo-fme-examples/go/config"
	vwo "github.com/wingify/vwo-fme-go-sdk"
)

// LogEntry represents a log entry
type LogEntry struct {
	Level   string `json:"level"`
	Message string `json:"message"`
}

var (
	vwoClient *vwo.VWOClient
	clientMu  sync.RWMutex
	logs      []LogEntry
	logsMu    sync.RWMutex
)

// InitVWOClient initializes the VWO client
func InitVWOClient() error {
	cfg, err := config.LoadConfig()
	if err != nil {
		return fmt.Errorf("failed to load config: %w", err)
	}

	options := map[string]interface{}{
		"sdkKey":    cfg.VWO.SDKKey,
		"accountId": cfg.VWO.AccountID,
		"logger": map[string]interface{}{
			"level":  "DEBUG",
			"prefix": "VWO-SDK",
		},
	}

	// Add custom logger transport
	loggerTransport := func(level string, message string) {
		logsMu.Lock()
		logs = append(logs, LogEntry{
			Level:   level,
			Message: message,
		})
		logsMu.Unlock()
	}

	// Set up logger with custom transport
	if loggerMap, ok := options["logger"].(map[string]interface{}); ok {
		loggerMap["transport"] = map[string]interface{}{
			"log": loggerTransport,
		}
	}

	// Add integrations callback
	options["integrations"] = map[string]interface{}{
		"Callback": func(properties map[string]interface{}) {
			propsJSON, _ := json.Marshal(properties)
			log.Printf("Integration callback called with properties: %s", string(propsJSON))
		},
	}

	client, err := vwo.Init(options)
	if err != nil {
		return fmt.Errorf("failed to initialize VWO client: %w", err)
	}

	clientMu.Lock()
	vwoClient = client
	clientMu.Unlock()

	return nil
}

// CreateUserContext creates a user context from the HTTP request
func CreateUserContext(req *http.Request) map[string]interface{} {
	cfg := config.GetConfig()

	userId := req.URL.Query().Get("userId")
	if userId == "" {
		userId = "defaultUser"
	}

	context := map[string]interface{}{
		"id": userId,
	}

	if len(cfg.VWO.CustomVariables) > 0 {
		context["customVariables"] = cfg.VWO.CustomVariables
	}

	userAgent := req.Header.Get("User-Agent")
	if userAgent != "" {
		context["userAgent"] = userAgent
	}

	ipAddress := req.RemoteAddr
	if ipAddress != "" {
		context["ipAddress"] = ipAddress
	}

	return context
}

// GetFlag retrieves the feature flag from VWO FME SDK
// Returns an interface{} that implements IsEnabled(), GetVariable(), and GetVariables() methods
func GetFlag(req *http.Request) (interface{}, error) {
	clientMu.RLock()
	client := vwoClient
	clientMu.RUnlock()

	if client == nil {
		return nil, fmt.Errorf("VWO client not initialized")
	}

	cfg := config.GetConfig()
	userContext := CreateUserContext(req)

	flag, err := client.GetFlag(cfg.VWO.FlagKey, userContext)
	if err != nil {
		return nil, fmt.Errorf("failed to get flag: %w", err)
	}

	return flag, nil
}

// TrackEvent tracks an event using VWO FME SDK
func TrackEvent(req *http.Request) error {
	clientMu.RLock()
	client := vwoClient
	clientMu.RUnlock()

	if client == nil {
		return fmt.Errorf("VWO client not initialized")
	}

	cfg := config.GetConfig()
	userContext := CreateUserContext(req)

	_, err := client.TrackEvent(cfg.VWO.EventName, userContext, nil)
	if err != nil {
		return fmt.Errorf("failed to track event: %w", err)
	}

	return nil
}

// SetAttribute sets user attributes using VWO FME SDK
func SetAttribute(req *http.Request) error {
	clientMu.RLock()
	client := vwoClient
	clientMu.RUnlock()

	if client == nil {
		return fmt.Errorf("VWO client not initialized")
	}

	cfg := config.GetConfig()
	userContext := CreateUserContext(req)

	err := client.SetAttribute(cfg.VWO.Attributes, userContext)
	if err != nil {
		return fmt.Errorf("failed to set attribute: %w", err)
	}

	return nil
}

// GetSettings retrieves the current VWO SDK settings
func GetSettings() interface{} {
	clientMu.RLock()
	defer clientMu.RUnlock()

	if vwoClient == nil {
		return nil
	}

	// Get settings from VWO client
	// GetOriginalSettings() returns a JSON string, so we need to unmarshal it
	settingsStr := vwoClient.GetOriginalSettings()

	// If settings string is empty, return empty object
	if settingsStr == "" {
		return map[string]interface{}{}
	}

	// Unmarshal the JSON string into an object
	var settings map[string]interface{}
	if err := json.Unmarshal([]byte(settingsStr), &settings); err != nil {
		// If unmarshaling fails, return empty object
		log.Printf("Error unmarshaling settings: %v", err)
		return map[string]interface{}{}
	}

	return settings
}

// GetLogs retrieves the SDK logs
func GetLogs() []LogEntry {
	logsMu.RLock()
	defer logsMu.RUnlock()

	// Return a copy of logs
	logsCopy := make([]LogEntry, len(logs))
	copy(logsCopy, logs)
	return logsCopy
}
