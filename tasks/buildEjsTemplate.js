const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest, parallel } = require('gulp');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');


const is_uninstall_package = options.is_uninstall_package
const use_platform = options.use_platform
const use_ratio = options.use_ratio
const use_compatibility = options.use_compatibility

function buildExtEjsTemplate(cb) {
  return is_uninstall_package ? cb() : src('ext_src/*.ejs')
    .pipe(gulpEjs({
      platform: use_platform,
      ratio: use_ratio,
      compatibility: use_compatibility
    }))
    .pipe(gulpRename({ extname: '.xml' }))
    .pipe(dest('temp/ext/'))
}

function buildSourceEjsTemplate(cb) {
  return is_uninstall_package ? cb() : src(['module_src/*.ejs','module_src/template/*.ejs'])
    .pipe(gulpEjs({
      platform: use_platform,
      ratio: use_ratio,
      compatibility: use_compatibility
    }))
    .pipe(gulpRename({ extname: '.xml' }))
    .pipe(dest('temp'))
}

module.exports = parallel(buildExtEjsTemplate,buildSourceEjsTemplate)