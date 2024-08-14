const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

const buildActionIsFold = function () {
  const use_platform = options.use_platform;
  return use_platform === 'fold';
}

/**
 * 折叠屏设备适配优化
 */
module.exports = function adaptivePlatformToFold(cb) {
  return src('temp/embedded_rules_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(buildActionIsFold, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = elementsWithAttribute.length - 1; i >= 0; i--) {
          const packageElement = elementsWithAttribute[i];

          // 如果节点包含fullRule属性，删除该节点
          // if (packageElement.getAttribute('fullRule')) {
          //   packageElement.parentNode.removeChild(packageElement);
          //   continue; // 跳过已删除的节点，继续下一个循环
          // }

          // 设置defaultSettings属性
          if (!packageElement.getAttribute('defaultSettings')) {
            packageElement.setAttribute('defaultSettings', 'true');
          }

          // 删除splitRatio属性
          const attrs = packageElement.attributes;
          for (let j = attrs.length - 1; j >= 0; j--) {
            if (attrs[j].name === 'splitRatio') {
              packageElement.removeAttribute(attrs[j].name);
            }
          }
        }

        return new XMLSerializer().serializeToString(doc);
      }
    })))
    .pipe(dest('temp'));
}