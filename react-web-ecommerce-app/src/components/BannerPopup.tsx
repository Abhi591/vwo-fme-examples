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
import { FC } from "react";
import { useAppDispatch, useAppSelector } from "../redux/hooks";
import { updateBanner } from "../redux/features/homeSlice";

const BannerPopup: FC = () => {
  const show = useAppSelector((state) => state.homeReducer.isBannerVisible);
  const dispatch = useAppDispatch();

  if (!show) return null;

  return (
    <div
      className={`fixed inset-0 flex items-center justify-center z-50 bg-black bg-opacity-50 transition-opacity duration-300 ${
        show ? "opacity-100" : "opacity-0 pointer-events-none"
      }`}
    >
      <div className="relative">
        <img
          src="/banner.jpg"
          alt="banner"
          className="w-[50vw] min-w-[300px] m-auto"
        />
        <button
          onClick={() => {
            dispatch(updateBanner(false));
          }}
          className="absolute top-0 right-0 m-2 bg-white rounded-full p-2"
        >
          ✖
        </button>
      </div>
    </div>
  );
};

export default BannerPopup;
