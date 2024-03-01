const { src, dest, parallel, series } = require('gulp');
const { cleanTemp } = require('./cleanDir');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');

const buildActionIsMagicWindow = function () {
  const use_mode = options.use_mode
  const is_magicWindow = use_mode === 'magicWindow'
  return is_magicWindow
}

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
 * 混入Android 11 下的平行窗口配置
 */

function copyMagicWindowApplicationList() {
  return src(`${tempDir}/magicWindowFeature_magic_window_application_list.xml`)
    .pipe(gulpIf(buildActionIsMagicWindow,dest(`${commonDist}/system/`)))
}

function copyMagicWindowSettingConfig() {
  return src(`${tempDir}/magic_window_setting_config.xml`)
  .pipe(gulpIf(buildActionIsMagicWindow,dest(`${commonDist}/system/users/0/`)))
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






module.exports = series(parallel(copyREADME,copyMagicWindowApplicationList,copyMagicWindowSettingConfig,copyOriginEmbeddedRuleListToCommon,copyEmbeddedRuleListToCommon,copyEmbeddedRuleListToSystem),cleanTemp)
