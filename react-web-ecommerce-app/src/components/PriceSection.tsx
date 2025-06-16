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
import useDiscount from "../hooks/useDiscount";

const PriceSection: FC<{ price: number; discountPercentage: number }> = ({
  price,
  discountPercentage = 0,
}) => {
  const result = useDiscount({ price, discount: discountPercentage });
  const discount = parseFloat(discountPercentage.toString());
  if (Math.floor(discount) === 0) {
    return <h2 className="font-medium text-blue-500 text-xl">${price}</h2>;
  }
  return (
    <div className="leading-3">
      <h2 className="font-medium text-blue-500 text-xl">
        ${result.toFixed(2)}
      </h2>
      <span className="mr-2 text-sm line-through opacity-70 dark:text-white">
        ${price}
      </span>
      <span className="text-sm font-semibold dark:text-white">
        -{discountPercentage}%
      </span>
    </div>
  );
};

export default PriceSection;
