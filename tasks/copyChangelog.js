const { src, dest } = require('gulp');
const { options } = require('../config/process.env');

const moduleUpdateVersion = options.module_update_version


module.exports = function copyChangelog(cb) {
  return src(`docs/changelog.md`)
  .pipe(dest(`docs/release/${moduleUpdateVersion}/`))
}