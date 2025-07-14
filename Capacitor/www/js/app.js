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

const products = {
    1: { id: 1, name: 'Product 1', price: '$10' },
    2: { id: 2, name: 'Product 2', price: '$20' },
    3: { id: 3, name: 'Product 3', price: '$30' },
  };

  function getQueryParam(param) {
    const urlParams = new URLSearchParams(window.location.search);
    return urlParams.get(param);
  }

  function addToCart() {
    const id = getQueryParam('id');
    let cart = JSON.parse(localStorage.getItem('cart')) || [];
    cart.push(products[id]);
    localStorage.setItem('cart', JSON.stringify(cart));
    alert('Product added to cart!');
  }

  window.onload = function () {
    if (document.getElementById('product-details')) {
      const id = getQueryParam('id');
      const product = products[id];
      document.getElementById('product-details').innerHTML =
        `<h2>${product.name}</h2><p>Price: ${product.price}</p>`;
    }

    if (document.getElementById('cart-list')) {
      const cart = JSON.parse(localStorage.getItem('cart')) || [];
      const list = cart.map(p => `<li>${p.name} - ${p.price}</li>`).join('');
      document.getElementById('cart-list').innerHTML = list || '<li>Your cart is empty.</li>';
    }
  };
