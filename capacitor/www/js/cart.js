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

const container = document.getElementById("cart-container");
const cartIds = JSON.parse(localStorage.getItem("cart") || "[]");

if (cartIds.length === 0) {
  container.innerHTML = `<p class="text-center text-gray-500">Your cart is empty.</p>`;
} else {
  const items = cartIds.map(id => products.find(p => p.id === id));
  let total = 0;
  const list = items.map(item => {
    total += item.price;
    return `<li class="border-b py-2">${item.name} - $${item.price.toFixed(2)}</li>`;
  }).join("");

  container.innerHTML = `
    <ul class="mb-4">${list}</ul>
    <p class="text-right font-bold">Total: $${total.toFixed(2)}</p>
    <button class="mt-4 bg-green-600 text-white px-4 py-2 rounded hover:bg-green-700">Checkout</button>
  `;
}
