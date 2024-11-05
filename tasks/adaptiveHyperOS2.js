const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest, parallel } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

const buildActionIsPad = function () {
  const use_platform = options.use_platform;
  const use_mode = options.use_mode;
  const mi_os_version = options.mi_os_version;
  return use_platform === 'pad' && use_mode === 'activityEmbedding' && mi_os_version >= 2;
}

/**
 * 小米平板 Hyper OS 2.0 适配优化
 */

function adaptiveEM(cb) {
  return src('temp/embedded_rules_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(buildActionIsPad, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = elementsWithAttribute.length - 1; i >= 0; i--) {
          const packageElement = elementsWithAttribute[i];
          // 设置skipSelfAdaptive属性
          if (!packageElement.getAttribute('skipSelfAdaptive') || packageElement.getAttribute('skipSelfAdaptive') !== 'false') {
            packageElement.setAttribute('skipSelfAdaptive', 'true');
          }
        }

        return new XMLSerializer().serializeToString(doc).replace(/\/>/g, ' />');
      }
    })))
    .pipe(dest('temp'))
    .on('end', cb);
}

function adaptiveFO(cb) {
  return src('temp/fixed_orientation_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(buildActionIsPad, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = elementsWithAttribute.length - 1; i >= 0; i--) {
          const packageElement = elementsWithAttribute[i];
          if (!packageElement.getAttribute('disable') || packageElement.getAttribute('disable') === 'false') {
            // 设置supportModes属性
            if (!packageElement.getAttribute('supportModes')) {
              packageElement.setAttribute('supportModes', 'full,fo');
            }
            // 设置skipSelfAdaptive属性
            if (!packageElement.getAttribute('skipSelfAdaptive') || packageElement.getAttribute('skipSelfAdaptive') !== 'false') {
              packageElement.setAttribute('skipSelfAdaptive', 'true');
            }
          }
        }

        return new XMLSerializer().serializeToString(doc).replace(/\/>/g, ' />');
      }
    })))
    .pipe(dest('temp'))
    .on('end', cb);
}

module.exports = parallel(adaptiveEM,adaptiveFO)