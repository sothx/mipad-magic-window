const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest, parallel } = require('gulp');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');


const is_uninstall_package = options.is_uninstall_package

function buildExtEjsTemplate(cb) {
  const use_platform = options.use_platform
  const use_ratio = options.use_ratio
  const use_compatibility = options.use_compatibility
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
  const use_platform = options.use_platform
  const use_ratio = options.use_ratio
  const use_compatibility = options.use_compatibility
  return is_uninstall_package ? cb() : src('module_src/*.ejs')
    .pipe(gulpEjs({
      platform: use_platform,
      ratio: use_ratio,
      compatibility: use_compatibility
    }))
    .pipe(gulpRename({ extname: '.xml' }))
    .pipe(dest('temp'))
}

module.exports = parallel(buildExtEjsTemplate,buildSourceEjsTemplate)