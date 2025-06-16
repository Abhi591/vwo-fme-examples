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
import React from "react";
import ReactDOM from "react-dom/client";
import App from "./App.tsx";
import "./index.css";
import { BrowserRouter } from "react-router-dom";
import { IVWOContextModel, IVWOOptions, VWOProvider} from "vwo-fme-react-sdk";  

const LoadingSpinner = () => (
  <div style={{
    display: 'flex',
    justifyContent: 'center',
    alignItems: 'center',
    height: '100vh',
    backgroundColor: '#f5f5f5'
  }}>
    <div style={{
      width: '50px',
      height: '50px',
      border: '5px solid #f3f3f3',
      borderTop: '5px solid #3498db',
      borderRadius: '50%',
      animation: 'spin 1s linear infinite'
    }} />
    <style>
      {`
        @keyframes spin {
          0% { transform: rotate(0deg); }
          100% { transform: rotate(360deg); }
        }
      `}
    </style>
  </div>
);

  function VWOProviderWrapper({children}: {children: React.ReactNode}) {
    const configOptions: IVWOOptions = {
      accountId: import.meta.env.VITE_VWO_ACCOUNT_ID,
      sdkKey: import.meta.env.VITE_VWO_SDK_KEY,
      logger: {
        level: import.meta.env.VITE_VWO_LOG_LEVEL,
      }
    };

    const userContext: IVWOContextModel = {
      id: import.meta.env.VITE_VWO_USER_ID
    }

    return (
      <VWOProvider config={configOptions} userContext={userContext} fallbackComponent={<LoadingSpinner />}>
        {children}
      </VWOProvider>
    );
    
  }

  ReactDOM.createRoot(document.getElementById("root")!).render(
    <VWOProviderWrapper>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </VWOProviderWrapper>
  );
