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
import { FC, useEffect, useState } from "react";
import { useParams } from "react-router-dom";
import { Product } from "../models/Product";
import ProductCard from "../components/ProductCard";

const SingleCategory: FC = () => {
  const { slug } = useParams();
  const [productList, setProductList] = useState<Product[]>([]);

  useEffect(() => {
    const fetchProducts = () => {
      fetch(`https://dummyjson.com/products/category/${slug}`)
        .then((res) => res.json())
        .then((data) => {
          const { products } = data;
          setProductList(products);
        });
    };

    fetchProducts();
  }, [slug]);

  return (
    <div className="container mx-auto min-h-[83vh] p-4 font-karla">
      <div className="flex items-center space-x-2 text-lg dark:text-white">
        <span>Categories</span>
        <span> {">"} </span>
        <span className="font-bold">{slug}</span>
      </div>
      <div className="grid gap-4 xl:grid-cols-4 lg:grid-cols-3 md:grid-cols-2 sm:grid-cols-1 my-2">
        {productList?.map((product) => (
          <ProductCard key={product.id} {...product} />
        ))}
      </div>
    </div>
  );
};

export default SingleCategory;
