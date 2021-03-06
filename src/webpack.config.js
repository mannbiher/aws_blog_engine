const path = require('path')

module.exports = {
    entry: [
        // '@babel/polyfill',
        './main.js',
    ],
    output: {
        path: path.resolve(__dirname, 'dist'),
        filename: 'bundle.js'
    },
    module: {
        rules: [
            {
                test: /\.jsx?$/,
                exclude: /(node_modules|bower_components)/,
                use: {
                    loader: 'babel-loader',
                    options: {
                        presets: [
                            '@babel/preset-env',
                            '@babel/preset-react',
                        ],
                        plugins: [
                            '@babel/plugin-proposal-object-rest-spread',
                            // '@babel/plugin-transform-async-to-generator',
                            // '@babel/plugin-transform-regenerator',
                        ]
                    }
                }
            }
        ]
    }
}