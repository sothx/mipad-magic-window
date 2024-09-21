const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

const buildActionIsGeneralTiramisu = function () {
  const use_compatibility = options.use_compatibility
  if (use_compatibility === 'general-tiramisu') {
    return true;
  }
  return false;
}

/**
 * 不支持左右滑动条的设备，默认分屏比例从0.3统一改为0.35(强迫症？)
 */
module.exports = function adaptiveCompatibilityToGeneralTiramisu(cb) {
  return src('temp/embedded_rules_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(buildActionIsGeneralTiramisu,gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const attrs = elementsWithAttribute[i].attributes;
          for (var j = attrs.length - 1; j >= 0; j--) {
            if (attrs[j].name === 'splitRatio') {
              if (elementsWithAttribute[i].getAttribute(attrs[j].name) === '0.3') {
                elementsWithAttribute[i].setAttribute(attrs[j].name,'0.35')
              }
            }
            // if (!elementsWithAttribute[i].getAttribute('splitLineColor') && !elementsWithAttribute[i].getAttribute('fullRule') && !elementsWithAttribute[i].getAttribute('middleRule')) {
            //   // 修改默认分割线的颜色为#E6E6E6
            //   elementsWithAttribute[i].setAttribute('splitLineColor','#E6E6E6')
            // }
          }
        }
        return new XMLSerializer().serializeToString(doc);
      }
    })))
    .pipe(gulpIf(buildActionIsGeneralTiramisu,dest('temp')))
    .on('end', cb);
}