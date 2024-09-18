const gulpzip = require('gulp-zip');
const { src, dest } = require('gulp');
const moduleConfig = require('../config/module.config.json');
const { options } = require('../config/process.env');
const gulpJSONEdit = require('gulp-json-editor');
const gulpRename = require('gulp-rename');
const gulpIf = require('gulp-if');

const moduleUpdateVersion = options.module_update_version

const lastModuleUpdateVersion = options.last_module_update_version

const isNeedBuildLastModuleUpdateVersion = () => {
  /** 停止提供V1版本自用版的更新 */
  const ignoreV1SothxExt = options.use_ext && options.netdisk_desc === 'sothx' && lastModuleUpdateVersion === 'V1'
  if (ignoreV1SothxExt) {
    return false;
  }
  return lastModuleUpdateVersion !== '' 
}

const packageName = `${options.use_platform}${options.use_ext ? `-ext` : ''}${options.use_mode === 'magicWindow' ? '-magicWindow' : ''}${options.use_compatibility ? `${'-' + options.use_compatibility}` : ''}`

module.exports = function buildUpdateMsg(cb) {
  const unNeedUpdate = () => {
    if (options.netdisk_desc === 'sothx') {
      return false;
    }
    if (options.use_ext) {
      return true
    }
    return false
  }
  return unNeedUpdate() ? cb() : src('module_src/template/release.json')
    .pipe(gulpJSONEdit(function (json) {
      json.version = moduleConfig.version
      json.versionCode = Number(moduleConfig.versionCode)
      json.zipUrl = `https://github.com/sothx/mipad-magic-window/releases/download/${moduleConfig.version}/${packageName}-${moduleConfig.version}.zip`
      json.changelog = `https://hyper-magic-window-module-update.sothx.com/release/${moduleUpdateVersion}/changelog.md`
      return json
    }))
    .pipe(gulpRename(`${packageName}.json`))
    .pipe(gulpIf(isNeedBuildLastModuleUpdateVersion,dest(`docs/release/${lastModuleUpdateVersion}/`)))
    .pipe(dest(`docs/release/${moduleUpdateVersion}/`))
}