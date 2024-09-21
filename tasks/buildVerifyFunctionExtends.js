const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const { includes } = require('lodash');

const verifyFunctionExtendsMap = {
    magicWindow: 'module_src/verify_function_extends/magicWindow/**',
    'general-tiramisu': 'module_src/verify_function_extends/general-tiramisu/**',
    'hyperos-based-on-tiramisu': 'module_src/verify_function_extends/hyperos-based-on-tiramisu/**',
    'liuqin-device-code': 'module_src/verify_function_extends/liuqin-device-code/**',
    'yudi-device-code': 'module_src/verify_function_extends/yudi-device-code/**',
    'sheng-device-code': 'module_src/verify_function_extends/sheng-device-code/**',
    'pipa-device-code': 'module_src/verify_function_extends/pipa-device-code/**'
}

const buildVerifyFunctionExtendsType = function () {
    if (['magicWindow'].includes(options.use_mode)) {

        return 'magicWindow'
    }
    if (['general-tiramisu','hyperos-based-on-tiramisu','liuqin-device-code','yudi-device-code','sheng-device-code','pipa-device-code'].includes(options.use_compatibility)) {
        return options.use_compatibility
    }
    return false;
}

module.exports = async function buildVerifyFunctionExtends(cb) {
    if (!buildVerifyFunctionExtendsType()) {
        cb()
    }
    return src(verifyFunctionExtendsMap[buildVerifyFunctionExtendsType()])
        .pipe(dest('dist'))
        .on('end', cb);
}