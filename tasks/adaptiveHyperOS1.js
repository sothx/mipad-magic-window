const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest, parallel } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

const buildActionIsOS1 = function () {
  const mi_os_version = options.mi_os_version;
  return mi_os_version === 1
}

/**
 * 小米平板 Hyper OS 1.0 适配优化
 */
function adaptiveEM(cb) {
  return src('temp/embedded_rules_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(buildActionIsOS1, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = elementsWithAttribute.length - 1; i >= 0; i--) {
          const packageElement = elementsWithAttribute[i];
          // 移除skipSelfAdaptive属性
          if (packageElement.getAttribute('skipSelfAdaptive')) {
            packageElement.removeAttribute('skipSelfAdaptive');
          }
          // 
        }

        return new XMLSerializer().serializeToString(doc).replace(/\/>/g, ' />');
      }
    })))
    .pipe(dest('temp'))
    .on('end', cb);
}

function adaptiveFO(cb) {
  return src('temp/fixed_orientation_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(buildActionIsOS1, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = elementsWithAttribute.length - 1; i >= 0; i--) {
          const packageElement = elementsWithAttribute[i];
          // 移除supportModes属性
          if (packageElement.getAttribute('supportModes')) {
            packageElement.removeAttribute('supportModes');
          }
          // 移除defaultSettings属性
          if (packageElement.getAttribute('defaultSettings')) {
            packageElement.removeAttribute('defaultSettings');
          }
          // 移除skipSelfAdaptive属性
          if (packageElement.getAttribute('skipSelfAdaptive')) {
            packageElement.removeAttribute('skipSelfAdaptive');
          }
        }

        return new XMLSerializer().serializeToString(doc).replace(/\/>/g, ' />');
      }
    })))
    .pipe(dest('temp'))
    .on('end', cb);
}

module.exports = parallel(adaptiveEM,adaptiveFO)