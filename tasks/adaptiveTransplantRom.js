const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');

const systemExtDist = 'dist/system/system_ext'
const moduleSrc = 'module_src'

const buildActionIsTransplant = function () {
  const is_transplant = options.is_transplant
  const is_pad = options.use_platform === 'pad'
  return is_transplant && is_pad
}

/**
 * 适配小米平板6Max移植包专用版
 */
module.exports = function adaptiveTransplantRom(cb) {
  return src(`${moduleSrc}/miui-embedding-window.jar`) // 指定XML文件的路径
    .pipe(gulpIf(buildActionIsTransplant, dest(`${systemExtDist}/framework/`)))
}