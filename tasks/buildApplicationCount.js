const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

// const buildSourceSrc = function () {
//   const use_mode = options.use_mode

//   if (use_mode === 'activityEmbedding') {
//     return 'temp/embedded_rules_list.xml'
//   }

//   if (use_mode === 'magicWindow') {
//     return 'temp/magicWindowFeature_magic_window_application_list.xml'
//   }

//   return ''
// }

/**
 * 统计适配应用总数
 */
module.exports = function buildApplicationCount(cb) {
  return src(options.use_mode === 'activityEmbedding' ? 'temp/embedded_rules_list.xml' : 'temp/magicWindowFeature_magic_window_application_list.xml') // 指定XML文件的路径
    .pipe(gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        const elementsWithAttribute = doc.getElementsByTagName('package');
        global.applicationRuleCount = elementsWithAttribute.length || ''
      }
    }))
}