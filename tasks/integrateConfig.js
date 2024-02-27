const { src, dest, parallel, series } = require('gulp');
const { cleanTemp } = require('./cleanDir');

const moduleSrc = 'module_src'
const tempDir = 'temp'
const commonDist = 'dist/common'
const systemDist = 'dist'

/**
 * 混入公共配置
 */

function copyREADME() {
  return src(`README.md`)
    .pipe(dest(`${systemDist}/`))
}

/**
 * 混入Android 12L 起的平行窗口配置
 */

function copyOriginEmbeddedRuleListToCommon() {
  return src(`${moduleSrc}/embedded_rules_list_bak`)
    .pipe(dest(`${commonDist}/product/etc/`))
}


function copyEmbeddedRuleListToCommon() {
  return src(`${tempDir}/embedded_rules_list.xml`)
    .pipe(dest(`${commonDist}/product/etc/`))
}

function copyEmbeddedRuleListToSystem() {
  return src(`${tempDir}/embedded_rules_list.xml`)
    .pipe(dest(`${systemDist}/product/etc/`))
}






module.exports = series(parallel(copyREADME,copyOriginEmbeddedRuleListToCommon,copyEmbeddedRuleListToCommon,copyEmbeddedRuleListToSystem),cleanTemp)
