const { src, dest } = require('gulp');
const { options } = require('../config/process.env');

const installTemplateMap = {
  generic: 'install_module_template/generic/**',
  ext: 'install_module_template/ext/**'
}

const getInstallTemplateType = function () {
  return options.use_ext ? 'ext' :'generic'
}

module.exports = function buildTemplate() {
  return src(installTemplateMap[getInstallTemplateType()])
         .pipe(dest('dist'))
}