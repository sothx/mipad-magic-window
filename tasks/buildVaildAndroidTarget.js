const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const { includes } = require('lodash');

const validAndroidTargetMap = {
    EQRedVelvetCake: 'module_src/valid_android_target/EQRedVelvetCake/**',
    LEToTiramisu: 'module_src/valid_android_target/LEToTiramisu/**',
    LEToUpsideDownCake: 'module_src/valid_android_target/LEToUpsideDownCake/**'
}

const buildVaildAndroidTargetType = function () {
    if (['magicWindow'].includes(options.use_mode)) {

        return 'EQRedVelvetCake'
    }
    if (['hyperos-based-on-tiramisu'].includes(options.use_compatibility)) {
        return 'LEToTiramisu'
    }
    if (['sheng-for-pad', 'yudi-for-pad', 'pipa-for-pad', 'liuqin-for-pad'].includes(options.use_compatibility)) {
        return 'LEToUpsideDownCake'
    }
    return false;
}

module.exports = async function buildVaildAndroidTarget(cb) {
    if (!buildVaildAndroidTargetType()) {
        cb()
    }
    return src(validAndroidTargetMap[buildVaildAndroidTargetType()])
        .pipe(dest('dist'))
}