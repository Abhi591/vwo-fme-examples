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

/* eslint-disable @typescript-eslint/no-explicit-any */
import { FC } from "react";
import { AiFillStar, AiOutlineStar } from "react-icons/ai";

const RatingStar: FC<{ rating: number }> = ({ rating }) => {
  const ratingNum = parseFloat(rating.toString());
  const main = Math.floor(ratingNum);
  const other = 5 - main;

  let showing: any;
  if (main === 1) {
    showing = <AiFillStar />;
  } else if (main === 2) {
    showing = (
      <>
        <AiFillStar />
        <AiFillStar />
      </>
    );
  } else if (main === 3) {
    showing = (
      <>
        <AiFillStar />
        <AiFillStar />
        <AiFillStar />
      </>
    );
  } else if (main === 4) {
    showing = (
      <>
        <AiFillStar />
        <AiFillStar />
        <AiFillStar />
        <AiFillStar />
      </>
    );
  } else if (main === 5) {
    showing = (
      <>
        <AiFillStar />
        <AiFillStar />
        <AiFillStar />
        <AiFillStar />
        <AiFillStar />
      </>
    );
  } else {
    showing = <></>;
  }

  let notShowing: any;
  if (other === 1) {
    notShowing = <AiOutlineStar />;
  } else if (other === 2) {
    notShowing = (
      <>
        <AiOutlineStar />
        <AiOutlineStar />
      </>
    );
  } else if (other === 3) {
    notShowing = (
      <>
        <AiOutlineStar />
        <AiOutlineStar />
        <AiOutlineStar />
      </>
    );
  } else if (other === 4) {
    notShowing = (
      <>
        <AiOutlineStar />
        <AiOutlineStar />
        <AiOutlineStar />
        <AiOutlineStar />
      </>
    );
  } else if (other === 5) {
    notShowing = (
      <>
        <AiOutlineStar />
        <AiOutlineStar />
        <AiOutlineStar />
        <AiOutlineStar />
        <AiOutlineStar />
      </>
    );
  } else {
    notShowing = <></>;
  }

  return (
    <div className="flex items-center text-[#ffb21d]">
      {showing}
      {notShowing}
      <span className="ml-2 text-gray-600 font-semibold dark:text-white">
        {rating}
      </span>
    </div>
  );
};

export default RatingStar;
