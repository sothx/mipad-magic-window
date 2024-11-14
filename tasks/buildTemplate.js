const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const { includes } = require('lodash');

const installTemplateMap = {
  generic: 'install_module_template/generic/**',
  os2_pad_generic: 'install_module_template/os2_pad_generic/**',
  ext: 'install_module_template/ext/**',
  projection: 'install_module_template/projection/**'
}

const getInstallTemplateType = function () {
  if (options.use_ext) {
    return 'ext';
  }
  if (options.is_projection) {
    return 'projection'
  }
  if (options.mi_os_version >= 2 && options.use_platform === 'pad') {
    return 'os2_pad_generic'
  }
  return 'generic'
}

module.exports = function buildTemplate(cb) {
  return src(installTemplateMap[getInstallTemplateType()])
         .pipe(dest('dist'))
         .on('end', cb);
}