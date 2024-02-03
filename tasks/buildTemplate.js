const { src, dest } = require('gulp');

module.exports = function buildTemplate() {
  return src('module_template/**')
  .pipe(dest('dist'))
}