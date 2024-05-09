const { src, dest } = require('gulp');
const { options } = require('../config/process.env');

const installTemplateMap = {
  generic: 'install_module_template/generic/**',
  ext: 'install_module_template/ext/**',
  'not-dragable': 'install_module_template/not-dragable/**',
  'pipa-for-hyperos': 'install_module_template/pipa-for-hyperos/**'
}

const getInstallTemplateType = function () {
  if (options.use_ext) {
    return 'ext';
  }
  if (options.use_compatibility === 'not-dragable') {
    return 'not-dragable'
  }
  if (options.use_compatibility === 'pipa-for-hyperos') {
    return 'pipa-for-hyperos'
  }
  return 'generic'
}

module.exports = function buildTemplate() {
  return src(installTemplateMap[getInstallTemplateType()])
         .pipe(dest('dist'))
}