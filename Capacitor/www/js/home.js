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

import { products } from "./data.js";

const container = document.getElementById("product-list");
products.forEach(p => {
  const card = document.createElement("div");
  card.className = "bg-white rounded-lg shadow p-4";
  card.innerHTML = `
    <img src="${p.image}" class="w-full h-40 object-cover rounded" />
    <h2 class="text-lg font-semibold mt-2">${p.name}</h2>
    <p class="text-gray-600">$${p.price.toFixed(2)}</p>
    <a href="product.html?id=${p.id}" class="text-blue-600 hover:underline mt-2 block">View Details</a>
  `;
  container.appendChild(card);
});
