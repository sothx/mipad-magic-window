const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest, parallel } = require('gulp');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');

const buildActionIsInstallPackage = function () {
  const is_uninstall_package = options.is_uninstall_package
  return !is_uninstall_package
}

function buildExtEjsTemplate() {
  const use_platform = options.use_platform
  const use_ratio = options.use_ratio
  const use_compatibility = options.use_compatibility
  return src('ext_src/*.ejs')
    .pipe(gulpIf(buildActionIsInstallPackage,gulpEjs({
      platform: use_platform,
      ratio: use_ratio,
      compatibility: use_compatibility
    })))
    .pipe(gulpIf(buildActionIsInstallPackage,gulpRename({ extname: '.xml' })))
    .pipe(gulpIf(buildActionIsInstallPackage,dest('temp/ext/')))
}

function buildSourceEjsTemplate() {
  const use_platform = options.use_platform
  const use_ratio = options.use_ratio
  const use_compatibility = options.use_compatibility
  return src('module_src/*.ejs')
    .pipe(gulpIf(buildActionIsInstallPackage,gulpEjs({
      platform: use_platform,
      ratio: use_ratio,
      compatibility: use_compatibility
    })))
    .pipe(gulpIf(buildActionIsInstallPackage,gulpRename({ extname: '.xml' })))
    .pipe(gulpIf(buildActionIsInstallPackage,dest('temp')))
}

module.exports = parallel(buildExtEjsTemplate,buildSourceEjsTemplate)