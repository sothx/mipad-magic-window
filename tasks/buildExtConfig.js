const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

const buildActionIsFold = function() {
  const use_platform = options.use_platform
  if (use_platform === 'fold') {
    return true;
  }
  return false;
}

let extConfigStack = {}

/**
 * 支持扩展应用规则(Only Android 12+)
 */
module.exports = function buildExtConfig() {
  return src('temp/ext/embedded_rules_list.xml') // 指定XML文件的路径
    .pipe(gulpXML({
        callback: function(result) {
          const doc = new DOMParser().parseFromString(result, 'text/xml');
          const elementsWithAttribute = doc.getElementsByTagName('package');
          // console.log(doc,'doc')
          for (let i = 0; i < elementsWithAttribute.length; i++) {
            const attrs = elementsWithAttribute[i].attributes;
            const currentAttrName = elementsWithAttribute[i].getAttribute('name')
            if (currentAttrName) {
              extConfigStack[currentAttrName] = {}
              for (var j = attrs.length - 1; j >= 0; j--) {
                extConfigStack[currentAttrName][attrs[j].name] = attrs[j].value
              }
            }
          }
        }
      }))
}