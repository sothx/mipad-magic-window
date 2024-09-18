const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');

const systemExtDist = 'dist/system/system_ext'
const moduleSrc = 'module_src'

const buildActionIsShengForHyperOS = function () {
  const use_compatibility = options.use_compatibility
  const is_ShengForHyperOS = use_compatibility === 'sheng-for-hyperos'
  return is_ShengForHyperOS
}

/**
 * 适配小米平板6S Pro Hyper OS For Pad
 */
module.exports = function adaptiveShengForHyperOS(cb) {
  return src(`${moduleSrc}/miui_embedding_window_service/ShengForHyperOS/miui-embedding-window.jar`) // 指定JAR文件的路径
    .pipe(gulpIf(buildActionIsShengForHyperOS, dest(`${systemExtDist}/framework/`)))
}