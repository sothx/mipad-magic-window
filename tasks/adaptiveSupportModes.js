const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

const buildActionIsPad = function () {
  const use_platform = options.use_platform;
  const use_mode = options.use_mode;
  return use_platform === 'pad' && use_mode === 'activityEmbedding';
}

/**
 * 小米平板 Hyper OS 2.0 适配优化
 */
module.exports = function adaptiveSupportModes(cb) {
  return src('temp/fixed_orientation_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(buildActionIsPad, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = elementsWithAttribute.length - 1; i >= 0; i--) {
          const packageElement = elementsWithAttribute[i];
          // 设置supportModes属性
          if (!packageElement.getAttribute('supportModes')) {
            packageElement.setAttribute('supportModes', 'full,fo');
          }
        }

        return new XMLSerializer().serializeToString(doc);
      }
    })))
    .pipe(dest('temp'))
    .on('end', cb);
}