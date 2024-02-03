const gulpzip = require('gulp-zip');
const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const through = require('through2');
const fs = require('fs');


function transformKeyValue(key, value) {
  return `${key}=${value}`;
}

module.exports = function jsonToProp() {
  return src('module_src/module.config.json')
  .pipe(through.obj((file, enc, cb) => {
    const json = JSON.parse(file.contents.toString());
    const keyValues = Object.keys(json).map(key => {
      const value = json[key];
      return transformKeyValue(key, value);
    }).join('\n');
    if (file.isBuffer()) {
      file.contents = Buffer.from(keyValues);
      cb(null, file);
    }
  }))
  .pipe(gulpRename('module.prop'))
  .pipe(dest('dist'))
}