const { src, dest, parallel, series } = require('gulp');
const { cleanTemp } = require('./cleanDir');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');
const gulpXML = require('gulp-xml');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;


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
  return src(`${tempDir}/magicWindowFeature_magic_window_application_list.xml`)
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
    .pipe(gulpIf(buildActionIsMagicWindow, dest(`${commonDist}/source/`)))
}

function copyMagicWindowSettingConfig(cb) {
  return src(`${tempDir}/magic_window_setting_config.xml`)
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
    .pipe(gulpIf(buildActionIsMagicWindow, dest(`${commonDist}/source/`)))
}

/**
 * 混入Android 11 的自定义规则模板
 */

function copyMagicWindowCustomConfigTemplateToCommon(cb) {
  return src(`${moduleSrc}/template/custom_config/magicWindow/*`)
  .pipe(gulpIf(buildActionIsMagicWindow,dest(`${commonDist}/template/`)))
}



/**
 * 混入Android 12L 起的平行窗口配置
 */


function copyEmbeddedRuleListToCommon(cb) {
  return src(`${tempDir}/embedded_rules_list.xml`)
    .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/source/`)))
}


/**
 * 混入Android 12L 起的修正方向位置的配置
 */


function copyFixedOrientationListToCommon(cb) {
  return src(`${tempDir}/fixed_orientation_list.xml`)
    .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/source/`)))
}

/**
 * 混入Android 12L 起的应用布局优化的配置
 */


function copyAutoUiListToCommon(cb) {
  return src(`${tempDir}/autoui_list.xml`)
    .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/source/`)))
}


/**
 * 混入Android 12L 起的Overlay配置
 */

// function copyActivityEmbeddingOverlayToCommon(cb) {
//   return src(`${moduleSrc}/overlay/*`)
//   .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/overlay`)))
// }

/**
 * 混入Android 12L 起的主题Overlay配置
 */

function copyActivityEmbeddingThemeOverlayToCommon(cb) {
  return src(`${moduleSrc}/theme_overlay/*`)
  .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/theme_overlay`)))
}

/**
 * 混入Android 12L 起的自定义规则模板
 */

function copyActivityEmbeddingCustomConfigTemplateToCommon(cb) {
  return src(`${moduleSrc}/template/custom_config/activityEmbedding/*`)
  .pipe(gulpIf(buildActionIsActivityEmbedding,dest(`${commonDist}/template/`)))
}


module.exports = series(parallel(copyREADME, series(copyMagicWindowApplicationList, copyMagicWindowSettingConfig,copyMagicWindowCustomConfigTemplateToCommon),copyEmbeddedRuleListToCommon,copyFixedOrientationListToCommon,copyAutoUiListToCommon,copyActivityEmbeddingCustomConfigTemplateToCommon,copyActivityEmbeddingThemeOverlayToCommon), cleanTemp)
