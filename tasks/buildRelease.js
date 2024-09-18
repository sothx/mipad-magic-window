const gulpzip = require('gulp-zip');
const { src, dest } = require('gulp');
const moduleConfig = require('../config/module.config.json');
const { options } = require('../config/process.env');

module.exports = function buildRelease(cb) {
  return src('dist/**')
    .pipe(gulpzip(`${options.use_platform}${options.use_ext ? `-ext` : ''}${options.use_mode === 'magicWindow' ? '-magicWindow' : ''}${options.use_compatibility ? `${'-' + options.use_compatibility}` : ''}-${moduleConfig.version}.zip`))
    .pipe(dest(`release/${moduleConfig.version}${options.use_ext ? '/ext' : ''}`))
  
}