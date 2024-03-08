const { src, dest } = require('gulp');
const { options } = require('../config/process.env');

const modeMap = {
  magicWindow: 'install_module_template/magicWindow/**',
  activityEmbedding: 'install_module_template/activityEmbedding/**'
}

const unInstallPackageMap = {
  magicWindow: 'uninstall_module_template/pad/magicWindow/**',
  activityEmbedding: 'uninstall_module_template/pad/activityEmbedding/**',
  fold: 'uninstall_module_template/fold/**'
}

module.exports = function buildTemplate() {
  return src(options.is_uninstall_package ? unInstallPackageMap[options.use_platform === 'fold' ? 'fold' : options.use_mode] :  modeMap[options.use_mode])
         .pipe(dest('dist'))
}