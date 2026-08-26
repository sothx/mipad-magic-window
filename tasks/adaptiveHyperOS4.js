const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest, parallel, series } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

const buildActionIsOS4Pad = function () {
  const use_platform = options.use_platform;
  const use_mode = options.use_mode;
  const mi_os_version = options.mi_os_version;
  return use_platform === 'pad' && use_mode === 'activityEmbedding' && mi_os_version >= 4;
}

// 缓存 embedded_rules 中包含非空 fullRule 属性的包名集合
const fullRulePackages = new Set();

/**
 * 第一步：读取 embedded_rules_list.xml，收集带非空 fullRule 的包名
 */
function adaptiveEM(cb) {
  return src('temp/embedded_rules_list.xml')
    .pipe(gulpIf(buildActionIsOS4Pad, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        const packageNodes = doc.getElementsByTagName('package');

        fullRulePackages.clear();

        for (let i = 0; i < packageNodes.length; i++) {
          const pkgNode = packageNodes[i];
          const pkgName = pkgNode.getAttribute('name');
          const fullRuleVal = pkgNode.getAttribute('fullRule');

          // 包名存在 + fullRule 属性存在且值非空
          if (pkgName && fullRuleVal !== null && fullRuleVal.trim() !== '') {
            fullRulePackages.add(pkgName);
          }
        }

        return new XMLSerializer().serializeToString(doc);
      }
    })))
    .pipe(dest('temp'))
    .on('end', cb);
}

/**
 * 第二步：处理 fixed_orientation_list.xml，按条件修改属性
 */
function adaptiveFO(cb) {
  return src('temp/fixed_orientation_list.xml')
    .pipe(gulpIf(buildActionIsOS4Pad, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        const packageNodes = doc.getElementsByTagName('package');

        for (let i = packageNodes.length - 1; i >= 0; i--) {
          const pkgNode = packageNodes[i];
          const pkgName = pkgNode.getAttribute('name');
          const isDisable = pkgNode.getAttribute('disable') === 'true';

          // 同时满足：embedded 有非空 fullRule + 当前节点 disable=true
          if (fullRulePackages.has(pkgName) && isDisable) {
            // 移除 disable 属性
            pkgNode.removeAttribute('disable');
            // setAttribute 原生支持「不存在则添加、存在则覆盖更新」
            pkgNode.setAttribute('supportModes', 'full,fo');
            pkgNode.setAttribute('defaultSettings', 'full');
            pkgNode.setAttribute('skipSelfAdaptive', 'true');
          }
        }

        return new XMLSerializer().serializeToString(doc).replace(/\/>/g, ' />');
      }
    })))
    .pipe(dest('temp'))
    .on('end', cb);
}

module.exports = series(adaptiveEM, adaptiveFO);
