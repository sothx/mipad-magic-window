const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const { includes } = require('lodash');

const verifyFunctionsExtendsMap = {
    magicWindow: 'module_src/verify_functions_extends/magicWindow/**',
    'general-vanillaIceCream': 'module_src/verify_functions_extends/general-vanillaIceCream/**',
    'general-tiramisu': 'module_src/verify_functions_extends/general-tiramisu/**',
    'general-upsideDownCake': 'module_src/verify_functions_extends/general-upsideDownCake/**',
    'hyperos-based-on-tiramisu': 'module_src/verify_functions_extends/hyperos-based-on-tiramisu/**',
    'liuqin-device-code': 'module_src/verify_functions_extends/liuqin-device-code/**',
    'dagu-device-code': 'module_src/verify_functions_extends/dagu-device-code/**',
    'yudi-device-code': 'module_src/verify_functions_extends/yudi-device-code/**',
    'sheng-device-code': 'module_src/verify_functions_extends/sheng-device-code/**',
    'pipa-device-code': 'module_src/verify_functions_extends/pipa-device-code/**',
    'miui-based-on-tiramisu': 'module_src/verify_functions_extends/miui-based-on-tiramisu/**'
}

const buildVerifyFunctionsExtendsType = function () {
    if (['magicWindow'].includes(options.use_mode)) {

        return 'magicWindow'
    }
    if (options.use_platform === 'pad' && options.use_compatibility === '' && !options.use_ext) {
        return 'general-vanillaIceCream'
    }
    if (['general-tiramisu','general-upsideDownCake','hyperos-based-on-tiramisu','liuqin-device-code','yudi-device-code','sheng-device-code','pipa-device-code','miui-based-on-tiramisu','dagu-device-code'].includes(options.use_compatibility)) {
        return options.use_compatibility
    }
    return false;
}

module.exports = async function buildVerifyFunctionsExtends(cb) {
    if (!buildVerifyFunctionsExtendsType()) {
        cb()
    }
    return src(verifyFunctionsExtendsMap[buildVerifyFunctionsExtendsType()])
        .pipe(dest('dist'))
        .on('end', cb);
}