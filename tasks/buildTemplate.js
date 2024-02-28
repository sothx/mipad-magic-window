const { src, dest } = require('gulp');
const { options } = require('../config/process.env');

const buildActionUseModeIsMagicWindow = function () {
  return options.use_mode === 'magicWindow'
}

const buildActionUseModeIsActivityEmbedding = function () {
  return options.use_mode === 'activityEmbedding'
}

module.exports = function buildTemplate() {
  return src(buildActionUseModeIsMagicWindow ? 'install_module_template/magicWindow/**' : (buildActionUseModeIsActivityEmbedding ? 'install_module_template/activityEmbedding/**' : ''))
    .pipe(dest('dist'))
}