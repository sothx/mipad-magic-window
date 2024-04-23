const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');

const systemExtDist = 'dist/system/system_ext'
const moduleSrc = 'module_src'

const buildActionIsHyperOSBasedOnTiramisu = function () {
  const use_compatibility = options.use_compatibility
  const is_HyperOSBasedOnTiramisu = use_compatibility === 'hyperos-based-on-tiramisu'
  return is_HyperOSBasedOnTiramisu
}

/**
 * 适配小米平板6Max移植包专用版
 */
module.exports = function adaptiveHyperOSBasedOnTiramisu(cb) {
  return src(`${moduleSrc}/miui_embedding_window_service/HyperOSBasedOnTiramisu/miui-embedding-window.jar`) // 指定JAR文件的路径
    .pipe(gulpIf(buildActionIsHyperOSBasedOnTiramisu, dest(`${systemExtDist}/framework/`)))
}