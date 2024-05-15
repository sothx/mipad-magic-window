const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest, parallel, series } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;
const fs = require('fs');
const blacklistApplicationsList = require('../config/blacklistApplications');

let hwConfigStack = {}

let OPPOConfigStack = {}

let activityEmbeddingStack = {}


const isUseHwConfig = function () {
  return options.use_merge_config_brand === 'hw';
}

const isUseOPPOConfig = function () {
  return options.use_merge_config_brand === 'oppo';
}


const isUseMagicWindow = function () {
  return options.use_mode === 'magicWindow';
}

const isUseActivityEmbedding = function () {
  return options.use_mode === 'activityEmbedding';
}


/**
 * 获取华为的平行视界规则
 */
function getHwMagicWindowConfigData() {
  return src('input_merge_config/hw_magicwindow_config/magic_window_application_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(isUseHwConfig, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const attrs = elementsWithAttribute[i].attributes;
          const currentAttrName = elementsWithAttribute[i].getAttribute('name')
          if (currentAttrName && !blacklistApplicationsList[currentAttrName]) {
            hwConfigStack[currentAttrName] = {}
            for (var j = attrs.length - 1; j >= 0; j--) {
              hwConfigStack[currentAttrName][attrs[j].name] = attrs[j].value
            }
          }
        }
        return JSON.stringify(hwConfigStack)
      }
    })))
    .pipe(gulpIf(isUseHwConfig, gulpRename('hw_magicwindow_config.json')))
    .pipe(gulpIf(isUseHwConfig, dest('output_temp/json/')))
}

/**
 * 获取OPPO的平行视界规则
 */
function getOPPOMagicWindowConfigData() {
  return src('input_merge_config/oppo_magicwindow_config/sys_fantasy_window_managed.xml') // 指定XML文件的路径
    .pipe(gulpIf(isUseOPPOConfig, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        const elementsWithAttribute = doc.getElementsByTagName('a');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const attrs = elementsWithAttribute[i].attributes;
          const currentAttrName = elementsWithAttribute[i].getAttribute('package_name')
          if (currentAttrName && !blacklistApplicationsList[currentAttrName]) {
            OPPOConfigStack[currentAttrName] = {}
            for (var j = attrs.length - 1; j >= 0; j--) {
              if (attrs[j].name === 'custom_config_body') {
                const currentConfigBody = attrs[j].value.replace(/\\/g, '').replace(/\^/g, '"')
                try {
                  const parseCurrentConfigBody = JSON.parse(currentConfigBody)
                  for (const [cbKey, cbValue] of Object.entries(parseCurrentConfigBody)) {
                    OPPOConfigStack[currentAttrName][cbKey] = cbValue
                  }
                } catch (e) {
                  console.warn(`${currentAttrName}发生JSON错误，请检查！`)
                  OPPOConfigStack[currentAttrName]['custom_config_body'] = currentConfigBody
                }
              } else {
                OPPOConfigStack[currentAttrName][attrs[j].name] = attrs[j].value
              }
            }
          }
        }
        return JSON.stringify(OPPOConfigStack)
      }
    })))
    .pipe(gulpIf(isUseOPPOConfig, gulpRename('oppo_magicwindow_config.json')))
    .pipe(gulpIf(isUseOPPOConfig, dest('output_temp/json/')))
}

/**
 * 获取OPPO的信箱模式规则
 */
function getOPPOCompactWindowConfigData() {
  return src('input_merge_config/oppo_magicwindow_config/sys_compact_window_managed.xml') // 指定XML文件的路径
    .pipe(gulpIf(isUseOPPOConfig, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        const elementsWithAttribute = doc.getElementsByTagName('c');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const attrs = elementsWithAttribute[i].attributes;
          const currentAttrName = elementsWithAttribute[i].getAttribute('package_name')
          if (currentAttrName && !blacklistApplicationsList[currentAttrName]) {
            OPPOConfigStack[currentAttrName] = {}
            for (var j = attrs.length - 1; j >= 0; j--) {
              if (attrs[j].name === 'custom_config_body') {
                const currentConfigBody = attrs[j].value.replace(/\\/g, '').replace(/\^/g, '"')
                try {
                  const parseCurrentConfigBody = JSON.parse(currentConfigBody)
                  for (const [cbKey, cbValue] of Object.entries(parseCurrentConfigBody)) {
                    OPPOConfigStack[currentAttrName][cbKey] = cbValue
                  }
                } catch (e) {
                  console.warn(`${currentAttrName}发生JSON错误，请检查！`)
                  OPPOConfigStack[currentAttrName]['custom_config_body'] = currentConfigBody
                }
              } else {
                OPPOConfigStack[currentAttrName][attrs[j].name] = attrs[j].value
              }
            }
          }
        }
        return JSON.stringify(OPPOConfigStack)
      }
    })))
    .pipe(gulpIf(isUseOPPOConfig, gulpRename('oppo_compact_window_config.json')))
    .pipe(gulpIf(isUseOPPOConfig, dest('output_temp/json/')))
}


function mergeToActivityEmbeddingConfig() {
  return src('input_merge_config/mi_magicwindow_config/embedded_rules_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(isUseOPPOConfig, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        // 获取根节点  
        const packageConfigNode = doc.getElementsByTagName('package_config')[0]
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const currentAttrName = elementsWithAttribute[i].getAttribute('name')
          if (OPPOConfigStack[currentAttrName]) {
            delete OPPOConfigStack[currentAttrName]
          }
        }
        for (const [key, value] of Object.entries(OPPOConfigStack)) {
          // 创建一个新元素  
          const newElement = doc.createElement('package');
          newElement.setAttribute('name', key)
          // TODO：设置视频全屏
          newElement.setAttribute('supportFullSize', 'true')
          for (const [vKey, vValue] of Object.entries(value)) {
            if (vKey !== 'name') {
              // 为新元素设置属性
              // TODO：左右滑动条
              if (vKey === 'force_custom_pw_mode' && vValue === 'true') {
                newElement.setAttribute('isShowDivider', 'true')
              }
              // TODO：分屏规则
              if (vKey === 'activityPairs' && vValue.length > 0) {
                let splitPairRule = ''
                vValue.map((splitPairItem, splitPairIndex) => {
                  splitPairRule += `${splitPairItem.from}:${splitPairItem.to}`
                  if (splitPairIndex !== vValue.length - 1) {
                    splitPairRule += ','
                  }
                })
                if (splitPairRule) {
                  newElement.setAttribute('splitPairRule', splitPairRule)
                }
              }
              // TODO：全屏规则
              if (vKey === 'Activities' && vValue.length > 0) {
                let activityRule = ''
                vValue.map((activityItem, activityIndex) => {
                  if (activityItem.name === '*') {
                    return;
                  }
                  if (activityItem.defaultFullScreen && activityItem.defaultFullScreen === 'true') {
                    activityRule += `${activityItem.name}`
                    if (activityIndex !== vValue.length - 1) {
                      activityRule += ','
                    }
                  }
                })
                if (activityRule) {
                  newElement.setAttribute('activityRule', activityRule)
                }
              }
              // TODO: 过渡规则
              if (vKey === 'transActivities' && vValue.length > 0) {
                let transitionRules = ''
                vValue.map((transitionItem, transitionIndex) => {
                  transitionRules += `${transitionItem}`
                  if (transitionIndex !== vValue.length - 1) {
                    transitionRules += ','
                  }
                })
                if (transitionRules) {
                  newElement.setAttribute('transitionRules', transitionRules)
                }
              }
              // 缩放
              if (vKey === 'scaleWindow' && vValue !== '-1') {
                newElement.setAttribute('scaleMode', 1)
                if (newElement.getAttribute('isShowDivider') === 'true') {
                  newElement.removeAttribute('isShowDivider')
                }
              }
              // 重载
              if (vKey === 'noRelaunchOnResize' && vValue === 'false') {
                newElement.setAttribute('relaunch', true)
              }
              // newElement.setAttribute(vKey, vValue);
            }
          }
          // 创建一个包含两个空格的文本节点  
          const spaceTextNode = doc.createTextNode('  '); // 两个空格  
          packageConfigNode.appendChild(spaceTextNode);
          // 将文本节点附加到新元素  
          packageConfigNode.appendChild(newElement);
          // 添加换行符
          const newLineNode = doc.createTextNode('\n');
          packageConfigNode.appendChild(newLineNode);
        }
        const serializedXml = new XMLSerializer().serializeToString(doc);
        // 使用正则表达式删除空行  
        const cleanedXml = serializedXml.replace(/^\s*[\r\n]|[\r\n]+\s*$/gm, '');
        return cleanedXml;
      }
    })))
    .pipe(gulpIf(isUseHwConfig, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        // 获取根节点  
        const packageConfigNode = doc.getElementsByTagName('package_config')[0]
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const currentAttrName = elementsWithAttribute[i].getAttribute('name')
          if (hwConfigStack[currentAttrName]) {
            delete hwConfigStack[currentAttrName]
          }
        }
        for (const [key, value] of Object.entries(hwConfigStack)) {
          // 创建一个新元素  
          const newElement = doc.createElement('package');
          newElement.setAttribute('name', key)
          // 为新元素设置属性
          // 0: 信箱模式
          if (value.window_mode === '0') {

            newElement.setAttribute('supportFullSize', 'true')
            newElement.setAttribute('procCompat', 'true')
            newElement.setAttribute('middleRule', '*')
          }
          // 1001: 强制横屏
          if (value.window_mode === '1001') {
            newElement.setAttribute('fullRule', '*')
          }
          // 1001: 平行视界
          if (value.window_mode === '1' || value.window_mode === '2') {
            // 左右滑动条
            if (value.is_dragable === 'true') {
              newElement.setAttribute('isShowDivider', 'true')
            }
            // 缩放
            if (value.is_scaled === 'true') {
              newElement.setAttribute('scaleMode', '1')
            }
            // 全屏视频
            if (value.support_fullscreen_video === 'true') {
              newElement.setAttribute('supportFullSize', 'true')
            }
            // 相机预览
            if (value.support_camera_preview === 'true') {
              newElement.setAttribute('supportCameraPreview', 'true')
            }
            // 是否需要重载
            if (value.need_relaunch === 'true') {
              newElement.setAttribute('relaunch', 'true')
            }
            // 默认设置
            if (value.default_setting === 'true') {
              newElement.setAttribute('defaultSettings', 'true')
            }
          }
          // 创建一个包含两个空格的文本节点  
          const spaceTextNode = doc.createTextNode('  '); // 两个空格  
          packageConfigNode.appendChild(spaceTextNode);
          // 将文本节点附加到新元素  
          packageConfigNode.appendChild(newElement);
          // 添加换行符
          const newLineNode = doc.createTextNode('\n');
          packageConfigNode.appendChild(newLineNode);
        }
        const serializedXml = new XMLSerializer().serializeToString(doc);
        // 使用正则表达式删除空行  
        const cleanedXml = serializedXml.replace(/^\s*[\r\n]|[\r\n]+\s*$/gm, '');
        return cleanedXml;
      }
    })))
    .pipe(dest('output_config'));
}

function mergeToMagicWindowApplicationListConfig() {
  return src('input_merge_config/mi_magicwindow_config/magicWindowFeature_magic_window_application_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(isUseHwConfig, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        // 获取根节点  
        const packageConfigNode = doc.getElementsByTagName('package_config')[0]
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const currentAttrName = elementsWithAttribute[i].getAttribute('name')
          if (hwConfigStack[currentAttrName]) {
            delete hwConfigStack[currentAttrName]
          }
        }
        for (const [key, value] of Object.entries(hwConfigStack)) {
          // 创建一个新元素  
          const newElement = doc.createElement('package');
          // 平行视界的模式
          const windowModeMap = {
            0: '0', // 信箱模式
            1001: '4', // 全屏模式
            1: '2', // 普通模式
            2: '2' // 递进模式
          }
          newElement.setAttribute('window_mode', windowModeMap[value.window_mode])
          for (const [vKey, vValue] of Object.entries(value)) {
            if (vKey !== 'name' && vKey !== 'window_mode' && vKey !== 'drag_to_fullscreen') {
              // 为新元素设置属性
              newElement.setAttribute(vKey, vValue);
            }
          }
          newElement.setAttribute('is_left_window_one_third', '');
          newElement.setAttribute('version', '');
          newElement.setAttribute('name', key)
          // 创建一个包含两个空格的文本节点  
          const spaceTextNode = doc.createTextNode('  '); // 两个空格  
          packageConfigNode.appendChild(spaceTextNode);
          // 将文本节点附加到新元素  
          packageConfigNode.appendChild(newElement);
          // 添加换行符
          const newLineNode = doc.createTextNode('\n');
          packageConfigNode.appendChild(newLineNode);
        }
        const serializedXml = new XMLSerializer().serializeToString(doc);
        // 使用正则表达式删除空行  
        const cleanedXml = serializedXml.replace(/^\s*[\r\n]|[\r\n]+\s*$/gm, '');
        return cleanedXml;
      }
    })))
    .pipe(gulpIf(isUseOPPOConfig, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        // 获取根节点  
        const packageConfigNode = doc.getElementsByTagName('package_config')[0]
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const currentAttrName = elementsWithAttribute[i].getAttribute('name')
          if (OPPOConfigStack[currentAttrName]) {
            delete OPPOConfigStack[currentAttrName]
          }
        }
        for (const [key, value] of Object.entries(OPPOConfigStack)) {
          // 创建一个新元素  
          const newElement = doc.createElement('package');
          // 为新元素设置属性
          newElement.setAttribute('window_mode', '2')
          newElement.setAttribute('support_multi_resume', 'false')
          newElement.setAttribute('is_left_window_one_third', '')
          newElement.setAttribute('notch_adapt', 'false')
          newElement.setAttribute('version', '')
          if (value.activityPairs && value.activityPairs.length > 0) {
            let homeRule = ''
            value.activityPairs.map((activityPairsItem, activityPairsIndex) => {
              homeRule += `${activityPairsItem.from}`
              if (activityPairsIndex !== value.activityPairs.length - 1) {
                homeRule += ','
              }
            })
            newElement.setAttribute('home', homeRule)
          } else {
            newElement.setAttribute('home', '')
          }
          // 左右滑动条
          newElement.setAttribute('is_dragable', value?.force_custom_pw_mode === 'true' ? 'true' : 'false')
          // 缩放
          newElement.setAttribute('is_scaled', (value.scaleWindow && value.scaleWindow !== '-1') ? 'true' : 'false')
          // 全屏视频
          newElement.setAttribute('support_fullscreen_video', 'true')
          // 相机预览
          newElement.setAttribute('support_camera_preview', value?.support_camera_preview === 'true' ? 'true' : 'false')
          // 是否需要重载
          newElement.setAttribute('need_relaunch', value?.noRelaunchOnResize === 'false' ? 'true' : 'false')
          // 默认设置
          newElement.setAttribute('default_setting', '')
          newElement.setAttribute('name', key)
          // 创建一个包含两个空格的文本节点  
          const spaceTextNode = doc.createTextNode('  '); // 两个空格  
          packageConfigNode.appendChild(spaceTextNode);
          // 将文本节点附加到新元素  
          packageConfigNode.appendChild(newElement);
          // 添加换行符
          const newLineNode = doc.createTextNode('\n');
          packageConfigNode.appendChild(newLineNode);
        }
        const serializedXml = new XMLSerializer().serializeToString(doc);
        // 使用正则表达式删除空行  
        const cleanedXml = serializedXml.replace(/^\s*[\r\n]|[\r\n]+\s*$/gm, '');
        return cleanedXml;
      }
    })))
    .pipe(dest('output_config'));
}

function mergeToOrientationConfig() {
  return src('input_merge_config/mi_magicwindow_config/fixed_orientation_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(isUseOPPOConfig, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        // 获取根节点  
        const packageConfigNode = doc.getElementsByTagName('package_config')[0]
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const currentAttrName = elementsWithAttribute[i].getAttribute('name')
          if (OPPOConfigStack[currentAttrName]) {
            delete OPPOConfigStack[currentAttrName]
          }
        }
        for (const [key, value] of Object.entries(OPPOConfigStack)) {
          // // 为新元素设置属性
          // newElement.setAttribute('window_mode', '2')
          // newElement.setAttribute('support_multi_resume', 'false')
          // newElement.setAttribute('is_left_window_one_third', '')
          // newElement.setAttribute('notch_adapt', 'false')
          // newElement.setAttribute('version', '')
          // if (value.activityPairs && value.activityPairs.length > 0) {
          //   let homeRule = ''
          //   value.activityPairs.map((activityPairsItem, activityPairsIndex) => {
          //     homeRule += `${activityPairsItem.from}`
          //     if (activityPairsIndex !== value.activityPairs.length - 1) {
          //       homeRule += ','
          //     }
          //   })
          //   newElement.setAttribute('home', homeRule)
          // } else {
          //   newElement.setAttribute('home', '')
          // }
         // 创建一个新元素  
          const newElement = doc.createElement('package');
          newElement.setAttribute('name', key)
          if (value?.status > 0) {
            newElement.setAttribute('supportFullSize', 'true')
            newElement.setAttribute('supportCameraPreview', 'true')
            if (value?.compact_ratio === '1.78') {
              // 信箱模式比例
              newElement.setAttribute('ratio','1.5')
            }
            if (value?.compact_relaunch) {
              // 重载
              newElement.setAttribute('relaunch',value?.compact_relaunch === '1' ? 'true' : 'false')
            }
            if (value?.scaleCompatMode) {
              // 压缩
              newElement.setAttribute('isScale',value?.scaleCompatMode === 'true' ? 'true' : 'false')
            }
            // 创建一个包含两个空格的文本节点  
            const spaceTextNode = doc.createTextNode('  '); // 两个空格  
            packageConfigNode.appendChild(spaceTextNode);
            // 将文本节点附加到新元素  
            packageConfigNode.appendChild(newElement);
            // 添加换行符
            const newLineNode = doc.createTextNode('\n');
            packageConfigNode.appendChild(newLineNode);
          }
        }
        const serializedXml = new XMLSerializer().serializeToString(doc);
        // 使用正则表达式删除空行  
        const cleanedXml = serializedXml.replace(/^\s*[\r\n]|[\r\n]+\s*$/gm, '');
        return cleanedXml;
      }
    })))
    .pipe(dest('output_config'));
}




module.exports = {
  mergeActivityEmbeddingConfig: series(getOPPOMagicWindowConfigData, getHwMagicWindowConfigData, mergeToActivityEmbeddingConfig),
  mergeMagicWindowConfig: series(getOPPOMagicWindowConfigData, getHwMagicWindowConfigData, mergeToMagicWindowApplicationListConfig),
  mergeOrientationConfig: series(getOPPOCompactWindowConfigData,mergeToOrientationConfig)
}