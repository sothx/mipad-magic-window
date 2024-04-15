const { src, dest } = require('gulp');
const { options } = require('../config/process.env');

const modeMap = {
  magicWindow: 'install_module_template/magicWindow/**',
  activityEmbedding: 'install_module_template/activityEmbedding/**'
}

module.exports = function buildTemplate() {
  return src(modeMap[options.use_mode])
         .pipe(dest('dist'))
}