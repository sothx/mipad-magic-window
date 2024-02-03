const gulpzip = require('gulp-zip');
const { src, dest } = require('gulp');

module.exports = function buildRelease() {
  return src('dist/**')
    .pipe(gulpzip('release.zip'))
    .pipe(dest('release'))
}