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
import React from 'react';
import { useVWOContext } from 'vwo-fme-react-sdk';

interface UpdateUserContextButtonProps {
  className?: string;
}

const UpdateUserContextButton: React.FC<UpdateUserContextButtonProps> = ({ className = '' }) => {
  const context = useVWOContext();

  const handleUpdateUser = () => {
    if (context && context.userContext && context.setUserContext) {
      // get user id and custom variables from env
      const userId = import.meta.env.VITE_VWO_USER_ID;

      context.setUserContext({
        id: userId
      });
    }
  };

  return (
    <button
      className={`inline-block bg-white rounded-md px-6 py-3 hover:bg-blue-500 hover:text-white ${className}`}
      onClick={handleUpdateUser}
    >
      Update ID
    </button>
  );
};

export default UpdateUserContextButton; 