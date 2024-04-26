const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest, parallel } = require('gulp');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');


const use_platform = options.use_platform
const use_ratio = options.use_ratio
const use_compatibility = options.use_compatibility
const use_ext = options.use_ext

const ejsParams = {
  platform: use_platform,
  ratio: use_ratio,
  compatibility: use_compatibility,
  ext: use_ext
}

function buildExtEjsTemplate(cb) {
  return src('ext_src/*.ejs')
    .pipe(gulpEjs(ejsParams))
    .pipe(gulpRename({ extname: '.xml' }))
    .pipe(dest('temp/ext/'))
}

function buildSourceEjsTemplate(cb) {
  return src(['module_src/*.ejs','module_src/template/*.ejs'])
    .pipe(gulpEjs(ejsParams))
    .pipe(gulpRename({ extname: '.xml' }))
    .pipe(dest('temp'))
}

module.exports = parallel(buildExtEjsTemplate,buildSourceEjsTemplate)