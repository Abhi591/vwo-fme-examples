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
import { FC, useEffect } from "react";
import HeroSection from "../components/HeroSection";
import Features from "../components/Features";
import TrendingProducts from "../components/TrendingProducts";
import { useAppDispatch } from "../redux/hooks";
import {
  updateNewList,
  updateFeaturedList,
} from "../redux/features/productSlice";
import { Product } from "../models/Product";
import LatestProducts from "../components/LatestProducts";
import Banner from "../components/Banner";
import { useGetFlag, useGetFlagVariable} from "vwo-fme-react-sdk";


const Home: FC = () => {
  const dispatch = useAppDispatch();
  const { flag } = useGetFlag(import.meta.env.VITE_VWO_FLAG_KEY_1);

  const discountPercentage = useGetFlagVariable<number>(flag, import.meta.env.VITE_VWO_FLAG1_NUMBER_VARIABLE_KEY, 10);
  const isBannerFirst = useGetFlagVariable(flag, import.meta.env.VITE_VWO_FLAG1_BOOLEAN_VARIABLE_KEY, false);

  const { flag: flag2 } = useGetFlag(import.meta.env.VITE_VWO_FLAG_KEY_2);
  const isTrendingFirst = useGetFlagVariable(flag2, import.meta.env.VITE_VWO_FLAG2_BOOLEAN_VARIABLE_KEY, true);


  useEffect(() => {
    const fetchProducts = () => {
      fetch("https://dummyjson.com/products?limit=24")
        .then((res) => res.json())
        .then(({ products }) => {
          const productList: Product[] = [];
          products.forEach((product: Product) => {
            productList.push({
              id: product.id,
              title: product.title,
              images: product.images,
              price: product.price,
              rating: product.rating,
              thumbnail: product.thumbnail,
              description: product.description,
              category: product.category,
              discountPercentage: product.discountPercentage,
            });
          });
          dispatch(updateFeaturedList(productList.slice(0, 8)));
          dispatch(updateNewList(productList.slice(8, 16)));
        });
    };
    fetchProducts();
  }, [dispatch]);

  return (
    <div className="dark:bg-slate-800">
      <HeroSection discountPercentage={discountPercentage} />
      <Features />
      {isBannerFirst ? (
        <>
          <Banner />
          {isTrendingFirst ? (
            <>
              <TrendingProducts />
              <LatestProducts />
            </>
          ) : (
            <>
              <LatestProducts />
              <TrendingProducts />
            </>
          )}
        </>
      ) : (
        <>
          {isTrendingFirst ? (
            <>
              <TrendingProducts />
              <Banner />
              <LatestProducts />
            </>
          ) : (
            <>
              <LatestProducts />
              <Banner />
              <TrendingProducts />
            </>
          )}
        </>
      )}
      <br />
    </div>
  );
};

export default Home;
