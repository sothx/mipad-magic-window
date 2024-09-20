const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const { includes } = require('lodash');

const installTemplateMap = {
  generic: 'install_module_template/generic/**',
  ext: 'install_module_template/ext/**',
  LEToTiramisu: 'install_module_template/LEToTiramisu/**',
  LEToUpsideDownCake: 'install_module_template/LEToUpsideDownCake/**'
}

const getInstallTemplateType = function () {
  if (options.use_ext) {
    return 'ext';
  }
  if ([].includes(options.use_compatibility)) {
    return 'LEToTiramisu'
  }
  if ([].includes(options.use_compatibility)) {
    return 'LEToUpsideDownCake'
  }
  return 'generic'
}

module.exports = function buildTemplate() {
  return src(installTemplateMap[getInstallTemplateType()])
         .pipe(dest('dist'))
}