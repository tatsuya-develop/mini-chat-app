const VueLoaderPlugin = require('vue-loader/lib/plugin')

module.exports = {
  devtool: 'inline-source-map',
  // モードの設定（設定しないと警告が出る）
  mode: 'development',
  // エントリーポイントの設定
  entry: {
    // 最初に読み始めるファイル
    application: './src/main.js',
  },
  output: {
    // 出力先のファイル
    path: __dirname + '/../app/assets/javascripts',
    filename: '[name].js'
  },
  module: {
    rules: [
      {
        test: /\.vue$/,
        loader: 'vue-loader'
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        loader: 'babel-loader'
      },
       {
        test: /\.(c|sc)ss$/,
        use: [
          'vue-style-loader',
          'css-loader',
          'sass-loader'
        ]
      }
    ]
  },
  plugins: [
    new VueLoaderPlugin()
  ]
}