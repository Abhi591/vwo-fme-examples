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

package routes

import (
	"encoding/json"
	"fmt"
	"log"
	"net/http"

	"github.com/gorilla/mux"
	"github.com/wingify/vwo-fme-examples/go/config"
	"github.com/wingify/vwo-fme-examples/go/utils"
)

// FlagResponse represents the response structure for get-flag endpoint
type FlagResponse struct {
	IsEnabled    bool                     `json:"isEnabled"`
	Variables    []map[string]interface{} `json:"variables"`
	Settings     interface{}              `json:"settings"`
	Logs         []utils.LogEntry         `json:"logs"`
	VariableKey1 string                   `json:"variablekey1"`
	VariableKey2 interface{}              `json:"variablekey2"`
}

// SuccessResponse represents a success/failure response
type SuccessResponse struct {
	Success bool `json:"success"`
}

// GetFlagHandler handles the /v1/get-flag endpoint
func GetFlagHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	flag, err := utils.GetFlag(r)
	if err != nil {
		log.Printf("Error getting feature flag: %v", err)
		response := FlagResponse{
			IsEnabled:    false,
			Variables:    []map[string]interface{}{},
			Settings:     nil,
			Logs:         []utils.LogEntry{},
			VariableKey1: "GPT-4",
			VariableKey2: []interface{}{},
		}
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(response)
		return
	}

	// Type assert to access methods
	// The flag object should have IsEnabled(), GetVariable(), and GetVariables() methods
	type FlagInterface interface {
		IsEnabled() bool
		GetVariable(key string, defaultValue interface{}) interface{}
		GetVariables() []map[string]interface{}
	}

	flagObj, ok := flag.(FlagInterface)
	if !ok {
		log.Printf("Error: flag does not implement expected interface")
		response := FlagResponse{
			IsEnabled:    false,
			Variables:    []map[string]interface{}{},
			Settings:     nil,
			Logs:         []utils.LogEntry{},
			VariableKey1: "GPT-4",
			VariableKey2: []interface{}{},
		}
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(response)
		return
	}

	isEnabled := flagObj.IsEnabled()
	variables := flagObj.GetVariables()

	settings := utils.GetSettings()
	logs := utils.GetLogs()

	cfg := config.GetConfig()
	variableKey1Raw := flagObj.GetVariable(cfg.VWO.VariableKey1, "GPT-4")
	variableKey2 := flagObj.GetVariable(cfg.VWO.VariableKey2, []interface{}{})

	// Type assert variableKey1 to string
	variableKey1, ok := variableKey1Raw.(string)
	if !ok {
		// If not a string, convert to string
		variableKey1 = fmt.Sprintf("%v", variableKey1Raw)
	}

	response := FlagResponse{
		IsEnabled:    isEnabled,
		Variables:    variables,
		Settings:     settings,
		Logs:         logs,
		VariableKey1: variableKey1,
		VariableKey2: variableKey2,
	}

	json.NewEncoder(w).Encode(response)
}

// TrackEventHandler handles the /v1/track-event endpoint
func TrackEventHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	err := utils.TrackEvent(r)
	if err != nil {
		log.Printf("Error tracking event: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(SuccessResponse{Success: false})
		return
	}

	json.NewEncoder(w).Encode(SuccessResponse{Success: true})
}

// SetAttributeHandler handles the /v1/set-attribute endpoint
func SetAttributeHandler(w http.ResponseWriter, r *http.Request) {
	w.Header().Set("Content-Type", "application/json")

	err := utils.SetAttribute(r)
	if err != nil {
		log.Printf("Error setting attribute: %v", err)
		w.WriteHeader(http.StatusInternalServerError)
		json.NewEncoder(w).Encode(SuccessResponse{Success: false})
		return
	}

	json.NewEncoder(w).Encode(SuccessResponse{Success: true})
}

// SetupRoutes configures all routes
func SetupRoutes() *mux.Router {
	router := mux.NewRouter()

	// API routes
	router.HandleFunc("/v1/get-flag", GetFlagHandler).Methods("GET")
	router.HandleFunc("/v1/track-event", TrackEventHandler).Methods("GET")
	router.HandleFunc("/v1/set-attribute", SetAttributeHandler).Methods("GET")

	return router
}
