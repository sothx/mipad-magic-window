const { src, dest } = require('gulp');
const del = require('del');
exports.default = function () {
  return del(['dist/*'])
}