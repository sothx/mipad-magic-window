const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');

const moduleUpdateVersion = options.module_update_version

const lastModuleUpdateVersion = options.last_module_update_version

const isNeedBuildLastModuleUpdateVersion = () => {
  return lastModuleUpdateVersion !== ''
}


module.exports = function copyChangelog(cb) {
  return src(`docs/changelog.md`)
  .pipe(gulpIf(isNeedBuildLastModuleUpdateVersion,dest(`docs/release/${lastModuleUpdateVersion}/`)))
  .pipe(dest(`docs/release/${moduleUpdateVersion}/`))
}