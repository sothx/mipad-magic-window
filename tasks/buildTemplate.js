const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const { includes } = require('lodash');

const installTemplateMap = {
  generic: 'install_module_template/generic/**',
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
  return 'generic'
}

module.exports = function buildTemplate(cb) {
  return src(installTemplateMap[getInstallTemplateType()])
         .pipe(dest('dist'))
         .on('end', cb);
}