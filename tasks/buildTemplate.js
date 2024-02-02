const { src, dest } = require('gulp');
exports.default = function () {
  return src('module_src/*').
    pipe(dest('dist'))
}