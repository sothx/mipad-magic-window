const { src, dest, parallel, series } = require('gulp');
const { cleanTemp } = require('./cleanDir');
const { options } = require('../config/process.env');
const moduleConfig = require('../config/module.config.json');
const gulpIf = require('gulp-if');

const releaseDir = `release`
const releaseNetdiskDir = `release/${moduleConfig.version}/netdisk`


function isSothxExtBuild() {
  return options.netdisk_desc === 'sothx'
}


/**
 * 拷贝网盘发行配置
 */

function releasePad(cb) {
  return src(`${releaseDir}/${moduleConfig.version}/pad-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/1.小米平板安卓15通用版（推荐安卓15）`))
    .on('end', cb);
}

function releaseGeneralUpsideDownCake(cb) {
  return src(`${releaseDir}/${moduleConfig.version}/pad-general-upsideDownCake-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/2.小米平板安卓14通用版（推荐安卓14）`))
    .on('end', cb);
}

function releaseGeneralTiramisu(cb) {
  return src(`${releaseDir}/${moduleConfig.version}/pad-general-tiramisu-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/3.小米平板安卓13通用版（无滑动调节）`))
    .on('end', cb);
}

function releasePadByMagicWindow(cb) {
  return src(`${releaseDir}/${moduleConfig.version}/pad-magicWindow-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/4.小米平板安卓11通用版`))
    .on('end', cb);
}

function releasePhone(cb) {
  return src(`${releaseDir}/${moduleConfig.version}/phone-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/5.小米手机妙享流转版`))
    .on('end', cb);
}

function releaseFold(cb) {
  return src(`${releaseDir}/${moduleConfig.version}/fold-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/6.小米折叠屏通用版（适配Mix Fold系列）`))
    .on('end', cb);
}

// function releasShengDeviceCode(cb) {
//   return src(`${releaseDir}/${moduleConfig.version}/pad-sheng-device-code-${moduleConfig.version}.zip`)
//     .pipe(dest(`${releaseNetdiskDir}/6.小米平板6S Pro澎湃专版(仅适配小米平板6S Pro)`))
//     .on('end', cb);
// }

function releasHyperOS1BasedOnUpsideDownCake(cb) {
  return src(`${releaseDir}/${moduleConfig.version}/pad-hyperos1-based-on-upsideDownCake-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/7.小米平板安卓14澎湃1.0专版(仅安卓14澎湃可刷，不支持红米平板)`))
    .on('end', cb);
}

function releasHyperOS2BasedOnVanillaIceCream(cb) {
  return src(`${releaseDir}/${moduleConfig.version}/pad-hyperos2-based-on-vanillaIceCream-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/8.小米平板安卓15澎湃2.0专版(仅安卓15澎湃2.0可刷)`))
    .on('end', cb);
}

function releasHyperOS2BasedOnUpsideDownCake(cb) {
  return src(`${releaseDir}/${moduleConfig.version}/pad-hyperos2-based-on-upsideDownCake-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/9.小米平板安卓14澎湃2.0专版(仅安卓14澎湃2.0可刷)`))
    .on('end', cb);
}

// function releasPipaDeviceCode(cb) {
//   return src(`${releaseDir}/${moduleConfig.version}/pad-pipa-device-code-${moduleConfig.version}.zip`)
//     .pipe(dest(`${releaseNetdiskDir}/8.小米平板6澎湃专版(仅适配小米平板6)`))
//     .on('end', cb);
// }

// function releaseYudiDeviceCode(cb) {
//   return src(`${releaseDir}/${moduleConfig.version}/pad-yudi-device-code-${moduleConfig.version}.zip`)
//     .pipe(dest(`${releaseNetdiskDir}/9.小米平板6 Max澎湃专版(仅适配小米平板6 Max)`))
//     .on('end', cb);
// }

// function releasDaguDeviceCode(cb) {
//   return src(`${releaseDir}/${moduleConfig.version}/pad-dagu-device-code-${moduleConfig.version}.zip`)
//     .pipe(dest(`${releaseNetdiskDir}/10.小米平板5 Pro 12.4澎湃专版(仅适配小米平板5 Pro 12.4)`))
//     .on('end', cb);
// }


function releasePadByHyperOSBasedOnTiramisu(cb) {
  return src(`${releaseDir}/${moduleConfig.version}/pad-hyperos-based-on-tiramisu-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/10.小米平板5系列安卓13澎湃专版（仅安卓13澎湃可刷）`))
    .on('end', cb);
}

function releasePadByMIUIBasedOnTiramisu(cb) {
  return src(`${releaseDir}/${moduleConfig.version}/pad-miui-based-on-tiramisu-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/11.小米平板6系列MIUI14专版（仅MIUI14可刷）`))
    .on('end', cb);
}


// function releaseExt(cb) {
//   return isSothxExtBuild() ? src(`${releaseDir}/${moduleConfig.version}/ext/pad-ext-${moduleConfig.version}.zip`)
//     .pipe(dest(`${releaseNetdiskDir}/X.自用版(个人测试模块，勿装)/模块`)) : cb()
// }




module.exports = parallel(releasePad,releasePhone,releasHyperOS1BasedOnUpsideDownCake,releasHyperOS2BasedOnVanillaIceCream,releasHyperOS2BasedOnUpsideDownCake,releaseFold, releasePadByMagicWindow, releaseGeneralUpsideDownCake,releaseGeneralTiramisu,releasePadByHyperOSBasedOnTiramisu,releasePadByMIUIBasedOnTiramisu)
