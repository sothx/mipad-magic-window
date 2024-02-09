const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest, parallel } = require('gulp');
const { options } = require('../config/process.env');

function buildExtEjsTemplate() {
  const use_platform = options.use_platform
  return src('src_ext/*.ejs')
    .pipe(gulpEjs({
      platform: use_platform
    }))
    .pipe(gulpRename({ extname: '.xml' }))
    .pipe(dest('temp/ext/'))
}

function buildSourceEjsTemplate() {
  const use_platform = options.use_platform
  return src('module_src/*.ejs')
    .pipe(gulpEjs({
      platform: use_platform
    }))
    .pipe(gulpRename({ extname: '.xml' }))
    .pipe(dest('temp'))
}

module.exports = parallel(buildExtEjsTemplate,buildSourceEjsTemplate)