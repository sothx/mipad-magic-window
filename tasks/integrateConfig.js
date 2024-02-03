const { src, dest, parallel } = require('gulp');

const moduleSrc = 'module_src'
const commonDist = '/dist/common'
const systemDist = '/dist'

function copyModuleProp() {
  return src(`${systemDist}/module.prop`)
  .pipe(dest(`${systemDist}/`))
}

function copyMagicWindowSettingConfig() {
  return src(`${moduleSrc}/magic_window_setting_config.xml`)
    .pipe(dest(`${commonDist}/system/users/0/`))
}

function copyMagicWindowApplicationList() {
  return src(`${moduleSrc}/magicWindowFeature_magic_window_application_list.xml`)
    .pipe(dest(`${systemDist}/system/`))
}


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




module.exports = parallel(copyModuleProp,copyMagicWindowSettingConfig, copyMagicWindowApplicationList, copyOriginEmbeddedRuleListToCommon, copyEmbeddedRuleListToCommon, copyEmbeddedRuleListToSystem)