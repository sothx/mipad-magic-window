const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const { includes } = require('lodash');

const verifyFunctionsExtendsMap = {
    magicWindow: 'module_src/verify_functions_extends/magicWindow/**',
    'general-vanillaIceCream': 'module_src/verify_functions_extends/general-vanillaIceCream/**',
    'general-tiramisu': 'module_src/verify_functions_extends/general-tiramisu/**',
    'general-upsideDownCake': 'module_src/verify_functions_extends/general-upsideDownCake/**',
    'hyperos-based-on-tiramisu': 'module_src/verify_functions_extends/hyperos-based-on-tiramisu/**',
    'hyperos1-based-on-upsideDownCake': 'module_src/verify_functions_extends/hyperos1-based-on-upsideDownCake/**',
    'hyperos2-based-on-vanillaIceCream': 'module_src/verify_functions_extends/hyperos2-based-on-vanillaIceCream/**',
    'miui-based-on-tiramisu': 'module_src/verify_functions_extends/miui-based-on-tiramisu/**',
    'general-phone': 'module_src/verify_functions_extends/general-phone/**'
}

const buildVerifyFunctionsExtendsType = function () {
    if (options.is_projection) {
        return 'general-phone'
    }
    if (['magicWindow'].includes(options.use_mode)) {

        return 'magicWindow'
    }
    if (options.use_platform === 'pad' && options.use_compatibility === '' && !options.use_ext) {
        return 'general-vanillaIceCream'
    }
    if (['general-tiramisu','general-upsideDownCake','hyperos-based-on-tiramisu','hyperos1-based-on-upsideDownCake','hyperos2-based-on-vanillaIceCream','miui-based-on-tiramisu'].includes(options.use_compatibility)) {
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