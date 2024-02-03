const gulpzip = require('gulp-zip');
const { src, dest } = require('gulp');
const moduleConfig = require('../module_src/module.config.json')

module.exports = function buildRelease() {
  const versionName = JSON.parse(moduleConfig).version
  return src('dist/**')
    .pipe(gulpzip(`${versionName}.zip`))
    .pipe(dest('release'))
}