const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

let packageStack = {}

/**
 * 统计适配应用总数
 */
module.exports = function buildApplicationCount(cb) {
  return src(options.use_mode === 'activityEmbedding' ? (options.use_platform === 'phone' ? ['temp/embedded_rules_list_projection.xml','temp/fixed_orientation_list_projection.xml','temp/generic_rules_list_projection.xml'] : options.mi_os_version >= 2 ? ['temp/embedded_rules_list.xml','temp/fixed_orientation_list.xml','temp/autoui_list.xml','temp/autoui2_list.xml'] : ['temp/embedded_rules_list.xml','temp/fixed_orientation_list.xml','temp/autoui_list.xml']) : 'temp/magicWindowFeature_magic_window_application_list.xml') // 指定XML文件的路径
    .pipe(gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const currentAttrName = elementsWithAttribute[i].getAttribute('name')
          if (currentAttrName) {
            packageStack[currentAttrName] = 1
          }
        }
        global.applicationRuleCount = Object.keys(packageStack).length || ''
      }
    }))
    .on('end', cb);
}