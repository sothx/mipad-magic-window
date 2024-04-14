const { src, dest, parallel, series } = require('gulp');
const { cleanTemp } = require('./cleanDir');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');
const gulpXML = require('gulp-xml');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;
const blacklistApplicationsList = require('../config/blacklistApplications');

const is_uninstall_package = options.is_uninstall_package

const buildActionIsMagicWindow = function () {
  const use_mode = options.use_mode
  const is_magicWindow = use_mode === 'magicWindow'
  return is_magicWindow
}

const buildActionIsActivityEmbedding = function () {
  const use_mode = options.use_mode
  const is_activityEmbedding = use_mode === 'activityEmbedding'
  return is_activityEmbedding
}

const moduleSrc = 'module_src'
const tempDir = 'temp'
const commonDist = 'dist/common'
const systemDist = 'dist'

let magicWindowApplicationListStack = {}

/**
 * 混入公共配置
 */

function copyREADME() {
  return src(`README.md`)
    .pipe(dest(`${systemDist}/`))
}


/**
 * 混入Android 11 下的平行窗口配置
 */

function copyMagicWindowApplicationList(cb) {
  return is_uninstall_package ? cb() : src(`${tempDir}/magicWindowFeature_magic_window_application_list.xml`)
    .pipe(gulpIf(buildActionIsMagicWindow,gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const attrs = elementsWithAttribute[i].attributes;
          const currentAttrName = elementsWithAttribute[i].getAttribute('name')
          if (currentAttrName) {
            magicWindowApplicationListStack[currentAttrName] = {}
            for (var j = attrs.length - 1; j >= 0; j--) {
              magicWindowApplicationListStack[currentAttrName][attrs[j].name] = attrs[j].value
            }
          }
        }
      }
    })))
    .pipe(gulpIf(buildActionIsMagicWindow, dest(`${commonDist}/system/`)))
}

function copyMagicWindowSettingConfig(cb) {
  return is_uninstall_package ? cb() : src(`${tempDir}/magic_window_setting_config.xml`)
    .pipe(gulpIf(buildActionIsMagicWindow,gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        // 获取根节点  
        const settingConfigNode = doc.getElementsByTagName('setting_config')[0]
        for (const [key] of Object.entries(magicWindowApplicationListStack)) {
          // 创建一个新元素  
          const newElement = doc.createElement('setting');
          newElement.setAttribute('name', key)
          newElement.setAttribute('miuiMagicWinEnabled', 'true')
          newElement.setAttribute('miuiDialogShown', 'false')
          newElement.setAttribute('miuiDragMode', '0')
          // 创建一个包含两个空格的文本节点  
          const spaceTextNode = doc.createTextNode('  '); // 两个空格  
          settingConfigNode.appendChild(spaceTextNode);
          // 将文本节点附加到新元素  
          settingConfigNode.appendChild(newElement);
          // 添加换行符
          const newLineNode = doc.createTextNode('\n');
          settingConfigNode.appendChild(newLineNode);
        }
        const serializedXml = new XMLSerializer().serializeToString(doc);
        // 使用正则表达式删除空行  
        const cleanedXml = serializedXml.replace(/^\s*[\r\n]|[\r\n]+\s*$/gm, '');
        return cleanedXml;
      }
    })))
    .pipe(gulpIf(buildActionIsMagicWindow, dest(`${commonDist}/system/users/0/`)))
}


/**
 * 混入Android 12L 起的平行窗口配置
 */

function copyOriginEmbeddedRuleListToCommon() {
  return src(`${moduleSrc}/backup_config/${options.use_platform}/embedded_rules_list_bak`)
    .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/product/etc/`)))
}


function copyEmbeddedRuleListToCommon(cb) {
  return is_uninstall_package ? cb() : src(`${tempDir}/embedded_rules_list.xml`)
    .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/product/etc/`)))
}

// function copyEmbeddedRuleListToCommonSource(cb) {
//   return is_uninstall_package ? cb() : src(`${tempDir}/embedded_rules_list.xml`)
//     .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/product/etc/source/`)))
// }

function copyEmbeddedRuleListToSystem(cb) {
  return is_uninstall_package ? cb() : src(`${tempDir}/embedded_rules_list.xml`)
  .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${systemDist}/product/etc/`)))
}

/**
 * 混入Android 12L 起的修正方向位置的配置
 */

function copyOriginOrientationListToCommon(cb) {
  return buildActionIsActivityEmbedding() ? src(`${moduleSrc}/backup_config/${options.use_platform}/fixed_orientation_list_bak`)
    .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/product/etc/`))) : cb()
}

// function copyFixedOrientationListToCommonSource(cb) {
//   return is_uninstall_package ? cb() : src(`${tempDir}/fixed_orientation_list.xml`)
//     .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/product/etc/source/`)))
// }

function copyFixedOrientationListToCommon(cb) {
  return is_uninstall_package ? cb() : src(`${tempDir}/fixed_orientation_list.xml`)
    .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/product/etc/`)))
}

function copyFixedOrientationListToSystem(cb) {
  return is_uninstall_package ? cb() : src(`${tempDir}/fixed_orientation_list.xml`)
    .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${systemDist}/product/etc/`)))
}




module.exports = series(parallel(copyREADME, series(copyMagicWindowApplicationList, copyMagicWindowSettingConfig), copyOriginEmbeddedRuleListToCommon, copyEmbeddedRuleListToCommon,copyEmbeddedRuleListToSystem,copyOriginOrientationListToCommon,copyFixedOrientationListToCommon,copyFixedOrientationListToSystem), cleanTemp)
