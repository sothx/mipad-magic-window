const gulpzip = require('gulp-zip');
const { src, dest } = require('gulp');
const moduleConfig = require('../config/module.config.json');
const { options } = require('../config/process.env');
const gulpFile = require('gulp-file');

const packageName = `${options.is_transplant ? 'transplant' : options.use_platform}${options.use_mode === 'magicWindow' ? '-magicWindow' : ''}${options.use_ratio === '3:2' ? '-ratioOf3To2' : ''}${options.use_compatibility ? `${'-' + options.use_compatibility}` : ''}`

module.exports = function buildUpdateMsg() {
  return src('')
    .pipe(gulpFile(`${packageName}.json`, JSON.stringify({
      version: moduleConfig.version,
      versionCode: Number(moduleConfig.versionCode),
      zipUrl: `https://github.com/sothx/mipad-magic-window/releases/download/${moduleConfig.version}/${packageName}-${moduleConfig.version}.zip`,
      changelog: 'https://hyper-magic-window-module-update.sothx.com/changelog.md'
    })))
  // return src('dist/**')
  //   .pipe(gulpzip(`${options.is_uninstall_package  ? 'uninstall-' : ''}${options.is_transplant ? 'transplant' : options.use_platform}${options.use_ext ? `-ext` : ''}${options.use_mode === 'magicWindow' ? '-magicWindow' : ''}${options.use_ratio === '3:2' ? '-ratioOf3To2' : ''}${options.use_compatibility ? `${'-' + options.use_compatibility}` : ''}-${options.is_uninstall_package ? '0.00.00' : moduleConfig.version}.zip`))
  //   .pipe(dest(`release/${moduleConfig.version}${options.use_ext ? '/ext' : ''}`))
}