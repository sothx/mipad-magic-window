const gulpzip = require('gulp-zip');
const { src, dest } = require('gulp');
const moduleConfig = require('../config/module.config.json');
const { options } = require('../config/process.env');


module.exports = function buildRelease() {
  return src('dist/**')
    .pipe(gulpzip(`${moduleConfig.version}.zip`))
    .pipe(dest(`release/${options.use_platform}/`))
}