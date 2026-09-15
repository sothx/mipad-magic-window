const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

const buildActionIsMixFold = function () {
  const use_platform = options.use_platform;
  const use_mode = options.use_mode;
  const mi_os_version = options.mi_os_version;
  return use_platform === 'fold' && use_mode === 'activityEmbedding' && mi_os_version <= 3;
}

/**
 * 折叠屏设备适配优化
 */
module.exports = function adaptivePlatformToMixFold(cb) {
  return src('temp/embedded_rules_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(buildActionIsMixFold, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');

        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = elementsWithAttribute.length - 1; i >= 0; i--) {
          const packageElement = elementsWithAttribute[i];

          // 如果节点包含fullRule属性，删除该节点
          if (packageElement.getAttribute('fullRule')) {
            packageElement.parentNode.removeChild(packageElement);
            continue; // 跳过已删除的节点，继续下一个循环
          }

          // 设置defaultSettings属性
          if (!packageElement.getAttribute('defaultSettings')) {
            packageElement.setAttribute('defaultSettings', 'true');
          }

          const attrs = packageElement.attributes;
          for (let j = attrs.length - 1; j >= 0; j--) {
            // 删除splitRatio属性
            if (attrs[j].name === 'splitRatio') {
              packageElement.removeAttribute(attrs[j].name);
            }
            // 删除splitMinWidth属性
            if (attrs[j].name === 'splitMinWidth') {
              packageElement.removeAttribute(attrs[j].name);
            }
          }
        }

        let xmlStr = new XMLSerializer().serializeToString(doc);
        // 把连续多行空白替换为单个换行，去掉首尾空白
        xmlStr = xmlStr.replace(/\n\s*\n/g, '\n').replace(/^\s+|\s+$/g, '');
        return xmlStr;
      }
    })))
    .pipe(dest('temp'))
    .on('end', cb);
}