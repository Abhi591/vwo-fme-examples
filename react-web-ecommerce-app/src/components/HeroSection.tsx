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
import { Link } from "react-router-dom";
import { useTrackEvent } from "vwo-fme-react-sdk";
import UpdateUserContextButton from "./UpdateUserContextButton";

interface HeroSectionProps {
  discountPercentage?: number;
}

const HeroSection: FC<HeroSectionProps> = ({ discountPercentage = 10 }) => {
  const { trackEvent } = useTrackEvent();
  return (
    <div className="bg-[#e3edf6] dark:bg-slate-600 font-lora">
      <div className="container px-4 grid md:grid-cols-2 py-8 mx-auto">
        <div className="flex items-center">
          <div className="max-w-[450px] space-y-4">
            <p className="text-black dark:text-white">
              Starting At <span className="font-bold">$999</span>
            </p>
            <h2 className="text-black font-bold text-4xl md:text-5xl dark:text-white">
              The best notebook collection 2024
            </h2>
            <h3 className="text-2xl dark:text-white">
              Exclusive offer <span className="text-red-600">-{discountPercentage}%</span> off
              this week
            </h3>
            <Link
              to="/product/6"
              data-test="hero-btn"
              className="inline-block bg-white rounded-md px-6 py-3 hover:bg-blue-500 hover:text-white" onClick={() => {
                trackEvent(import.meta.env.VITE_VWO_EVENT_KEY)
              }}>
              Shop Now
            </Link>
            <UpdateUserContextButton className="ml-4" />
          </div>
        </div>
        <div>
          <img src="/hero.png" alt="hero" className="ml-auto" />
        </div>
      </div>
    </div>
  );
};

export default HeroSection;
