const { src, dest } = require('gulp');
const { options } = require('../config/process.env');

const installTemplateMap = {
  generic: 'install_module_template/generic/**',
  transplant: 'install_module_template/transplant/**'
}

const buildActionIsTransplant = function () {
  const is_transplant = options.is_transplant
  const is_pad = options.use_platform === 'pad'
  return is_transplant && is_pad
}

module.exports = function buildTemplate() {
  return src(modeMap[buildActionIsTransplant()])
         .pipe(dest('dist'))
}