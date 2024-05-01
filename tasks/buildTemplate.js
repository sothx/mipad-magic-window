const { src, dest } = require('gulp');
const { options } = require('../config/process.env');

const installTemplateMap = {
  generic: 'install_module_template/generic/**',
  ext: 'install_module_template/ext/**',
  'not-dragable': 'install_module_template/not-dragable/**'
}

const getInstallTemplateType = function () {
  if (options.use_ext) {
    return 'ext';
  }
  if (options.use_compatibility) {
    return 'not-dragable'
  }
  return 'generic'
}

module.exports = function buildTemplate() {
  return src(installTemplateMap[getInstallTemplateType()])
         .pipe(dest('dist'))
}