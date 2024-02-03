const { src, dest, parallel } = require('gulp');

const moduleSrc = 'module_src'
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
 * 混入Android 11 下的平行窗口配置
 */

function copyMagicWindowApplicationList() {
  return src(`${moduleSrc}/magicWindowFeature_magic_window_application_list.xml`)
    .pipe(dest(`${commonDist}/system/`))
}

function copyMagicWindowSettingConfig() {
  return src(`${moduleSrc}/magic_window_setting_config.xml`)
  .pipe(dest(`${commonDist}/system/users/0/`))
}


/**
 * 混入Android 12L 起的平行窗口配置
 */

function copyOriginEmbeddedRuleListToCommon() {
  return src(`${moduleSrc}/embedded_rules_list_bak`)
    .pipe(dest(`${commonDist}/product/etc/`))
}


function copyEmbeddedRuleListToCommon() {
  return src(`${moduleSrc}/embedded_rules_list.xml`)
    .pipe(dest(`${commonDist}/product/etc/`))
}

function copyEmbeddedRuleListToSystem() {
  return src(`${moduleSrc}/embedded_rules_list.xml`)
    .pipe(dest(`${systemDist}/product/etc/`))
}






module.exports = parallel(copyREADME,copyMagicWindowApplicationList,copyMagicWindowSettingConfig,copyOriginEmbeddedRuleListToCommon,copyEmbeddedRuleListToCommon,copyEmbeddedRuleListToSystem)
