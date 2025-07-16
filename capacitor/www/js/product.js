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

// product.js
import { products } from "./data.js";

const id = new URLSearchParams(window.location.search).get("id");
const product = products.find(p => p.id === Number(id));

document.getElementById("product-details").innerHTML = `
  <img src="${product.image}" class="w-full h-60 object-cover rounded mb-4" />
  <h2 class="text-2xl font-bold">${product.name}</h2>
  <p class="text-gray-700 mt-2">${product.description}</p>
  <p id="pPrice" class="text-xl font-semibold mt-4">$${product.price.toFixed(2)}</p>
  <button id="add-to-cart" class="mt-4 bg-blue-600 text-white px-4 py-2 rounded hover:bg-blue-700">Add to Cart</button>
`;

document.getElementById("add-to-cart").addEventListener("click", () => {
  const cart = JSON.parse(localStorage.getItem("cart") || "[]");
  cart.push(product.id); // store only ID
  localStorage.setItem("cart", JSON.stringify(cart));
  alert("Added to cart!");
});
