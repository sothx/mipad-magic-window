const { src, dest } = require('gulp');
const { options } = require('../config/process.env');

const installTemplateMap = {
  generic: 'install_module_template/generic/**'
}

const getInstallTemplateType = function () {
  return 'generic'
}

module.exports = function buildTemplate() {
  return src(installTemplateMap[getInstallTemplateType()])
         .pipe(dest('dist'))
}