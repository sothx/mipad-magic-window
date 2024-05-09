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

function releasePad() {
  return src(`${releaseDir}/${moduleConfig.version}/pad-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/1.小米平板通用版（推荐安卓14+）/模块`))
}

function releaseHyperOsForTiramisu() {
  return src(`${releaseDir}/${moduleConfig.version}/pad-not-dragable-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/2.小米平板安卓13通用版（无滑动调节）/模块`))
}

function releasePadByMagicWindow() {
  return src(`${releaseDir}/${moduleConfig.version}/pad-magicWindow-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/3.小米平板安卓11通用版/模块`))
}

function releaseFold() {
  return src(`${releaseDir}/${moduleConfig.version}/fold-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/4.小米折叠屏通用版（适配Mix Fold系列）/模块`))
}

function releaseRatioOf3To2Pad() {
  return src(`${releaseDir}/${moduleConfig.version}/pad-ratioOf3To2-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/5.小米平板6S Pro澎湃专版(适配3比2比例)/模块`))
}

function releasPipaForHyperOS() {
  return src(`${releaseDir}/${moduleConfig.version}/pad-ratioOf3To2-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/6.小米平板6(pipa)澎湃专版(仅适配小米平板6)/模块`))
}

function releasePadByHyperOSBasedOnTiramisu() {
  return src(`${releaseDir}/${moduleConfig.version}/pad-hyperos-based-on-tiramisu-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/7.小米平板5系列安卓13澎湃专版（仅安卓13澎湃可刷）/模块`))
}

function releasePadByTransplant6MaxBasedOnTiramisu() {
  return src(`${releaseDir}/${moduleConfig.version}/pad-transplant-6max-based-on-tiramisu-${moduleConfig.version}.zip`)
    .pipe(dest(`${releaseNetdiskDir}/8.基于MIUI14的6 Max移植包专版（仅MIUI14移植可刷）/模块`))
}


// function releaseExt(cb) {
//   return isSothxExtBuild() ? src(`${releaseDir}/${moduleConfig.version}/ext/pad-ext-${moduleConfig.version}.zip`)
//     .pipe(dest(`${releaseNetdiskDir}/X.自用版(个人测试模块，勿装)/模块`)) : cb()
// }




module.exports = parallel(releasePad, releaseRatioOf3To2Pad,releasPipaForHyperOS, releaseFold, releasePadByMagicWindow, releaseHyperOsForTiramisu, releasePadByTransplant6MaxBasedOnTiramisu,releasePadByHyperOSBasedOnTiramisu)
