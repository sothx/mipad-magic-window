const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const { options } = require('../config/process.env');

module.exports = function buildEjsTemplate() {
  const use_platform = options.use_platform
  return src('module_src/*.ejs')
    .pipe(gulpEjs({
      platform: use_platform
    }))
    .pipe(gulpRename({ extname: '.xml' }))
    .pipe(dest('temp'))
}