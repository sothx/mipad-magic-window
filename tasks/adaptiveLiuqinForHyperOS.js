const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');

const systemExtDist = 'dist/system/system_ext'
const moduleSrc = 'module_src'

const buildActionIsLiuqinForHyperOS = function () {
  const use_compatibility = options.use_compatibility
  const is_HyperOSBasedOnTiramisu = use_compatibility === 'hyperos-based-on-tiramisu'
  return is_HyperOSBasedOnTiramisu
}

/**
 * 适配小米平板6 Pro Hyper OS For Pad
 */
module.exports = function adaptiveLiuqinForHyperOS(cb) {
  return src(`${moduleSrc}/miui_embedding_window_service/LiuqinForHyperOS/miui-embedding-window.jar`) // 指定JAR文件的路径
    .pipe(gulpIf(buildActionIsLiuqinForHyperOS, dest(`${systemExtDist}/framework/`)))
}