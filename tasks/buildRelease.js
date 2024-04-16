const gulpzip = require('gulp-zip');
const { src, dest } = require('gulp');
const moduleConfig = require('../config/module.config.json');
const { options } = require('../config/process.env');

const moduleUpdateVersion = options.module_update_version

module.exports = function buildRelease(cb) {
  return src('dist/**')
    .pipe(gulpzip(`${options.is_transplant ? 'transplant' : options.use_platform}${options.use_ext ? `-ext` : ''}${options.use_mode === 'magicWindow' ? '-magicWindow' : ''}${options.use_ratio === '3:2' ? '-ratioOf3To2' : ''}${options.use_compatibility ? `${'-' + options.use_compatibility}` : ''}-${moduleConfig.version}.zip`))
    .pipe(dest(`release/${moduleConfig.version}${options.use_ext ? '/ext' : ''}`))
  
}