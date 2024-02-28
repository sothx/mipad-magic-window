const { src, dest } = require('gulp');

module.exports = function buildTemplate() {
  return src('install_module_template/**')
  .pipe(dest('dist'))
}