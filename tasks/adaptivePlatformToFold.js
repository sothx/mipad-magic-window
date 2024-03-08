const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

const buildActionIsFold = function () {
  const use_platform = options.use_platform
  const is_uninstall_package = options.is_uninstall_package
  if (use_platform === 'fold' && !is_uninstall_package) {
    return true;
  }
  return false;
}

/**
 * 折叠屏设备不适配splitRatio参数，统一去除
 */
module.exports = function adaptivePlatformToFold() {
  return src('temp/embedded_rules_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(buildActionIsFold,gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const attrs = elementsWithAttribute[i].attributes;
          for (var j = attrs.length - 1; j >= 0; j--) {
            if (attrs[j].name === 'splitRatio') {
                elementsWithAttribute[i].removeAttribute(attrs[j].name);
            }
          }
        }
        return new XMLSerializer().serializeToString(doc);
      }
    })))
    .pipe(dest('temp'));
}