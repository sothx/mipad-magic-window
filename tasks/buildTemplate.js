const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const { includes } = require('lodash');

const installTemplateMap = {
  generic: 'install_module_template/generic/**',
  os2_pad_generic: 'install_module_template/os2_pad_generic/**',
  os3_pad_generic: 'install_module_template/os3_pad_generic/**',
  ext: 'install_module_template/ext/**',
  phone: 'install_module_template/phone/**',
  fold: 'install_module_template/fold/**'
}

const getInstallTemplateType = function () {
  if (options.use_ext) {
    return 'ext';
  }
  if (options.use_platform === 'phone') {
    return 'phone'
  }
  if (options.use_platform === 'fold') {
    return 'fold'
  }
  if (options.mi_os_version >= 2 && options.use_platform === 'pad') {
    return 'os2_pad_generic'
  }
  if (options.mi_os_version >= 3 && options.use_platform === 'pad') {
    return 'os3_pad_generic'
  }
  return 'generic'
}

module.exports = function buildTemplate(cb) {
  return src(installTemplateMap[getInstallTemplateType()])
         .pipe(dest('dist'))
         .on('end', cb);
}