const webpack = require('webpack');
require('dotenv').config();

module.exports = {
  plugins: [
    new webpack.DefinePlugin({
      'process.env': {
        VWO_ACCOUNT_ID: JSON.stringify(process.env.VWO_ACCOUNT_ID),
        VWO_SDK_KEY: JSON.stringify(process.env.VWO_SDK_KEY),
        VWO_FLAG_KEY: JSON.stringify(process.env.VWO_FLAG_KEY)
      }
    })
  ]
}; 