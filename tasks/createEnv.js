const gulpzip = require('gulp-zip');
const { src, dest } = require('gulp');
const moduleConfig = require('../module_src/module.config.json')

module.exports = function buildRelease() {
  return src('dist/**')
    .pipe(gulpzip(`${moduleConfig.version}.zip`))
    .pipe(dest('release'))
}