const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');

module.exports = function buildEjsTemplate() {
  return src('module_src/*.ejs')
    .pipe(gulpEjs({
      age: 13
    }))
    .pipe(gulpRename({ extname: '.xml' }))
    .pipe(dest('temp'))
}