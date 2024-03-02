const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest, parallel, series } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;
const fs = require('fs')

let hwConfigStack = {}

let OPPOConfigStack = {}


const isUseHwConfig = function() {
  return options.use_merge_config_brand === 'hw';
}

const isUseOPPOConfig = function() {
  return options.use_merge_config_brand === 'oppo';
}


const isUseMagicWindow = function() {
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
    .pipe(gulpIf(isUseHwConfig,gulpXML({
      callback: function(result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const attrs = elementsWithAttribute[i].attributes;
          const currentAttrName = elementsWithAttribute[i].getAttribute('name')
          if (currentAttrName) {
            hwConfigStack[currentAttrName] = {}
            for (var j = attrs.length - 1; j >= 0; j--) {
              hwConfigStack[currentAttrName][attrs[j].name] = attrs[j].value
            }
          }
        }
        return JSON.stringify(hwConfigStack)
      }
    })))
    .pipe(gulpIf(isUseHwConfig,gulpRename('hw_magicwindow_config.json')))
    .pipe(gulpIf(isUseHwConfig,dest('output_temp/json/')))
}

/**
 * 获取OPPO的平行视界规则
 */
function getOPPOMagicWindowConfigData() {
  return src('input_merge_config/oppo_magicwindow_config/sys_fantasy_window_managed.xml') // 指定XML文件的路径
    .pipe(gulpIf(isUseOPPOConfig,gulpXML({
      callback: function(result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        const elementsWithAttribute = doc.getElementsByTagName('a');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const attrs = elementsWithAttribute[i].attributes;
          const currentAttrName = elementsWithAttribute[i].getAttribute('package_name')
          if (currentAttrName) {
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
    .pipe(gulpIf(isUseOPPOConfig,gulpRename('oppo_magicwindow_config.json')))
    .pipe(gulpIf(isUseOPPOConfig,dest('output_temp/json/')))
}


function mergeToActivityEmbeddingConfig() {
  return src('input_merge_config/oppo_magicwindow_config/sys_fantasy_window_managed.xml') // 指定XML文件的路径
    .pipe(gulpIf(isNeedExtConfig,gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        // 获取根节点  
        const packageConfigNode = doc.getElementsByTagName('package_config')[0]
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const currentAttrName = elementsWithAttribute[i].getAttribute('name')
          if (extConfigStack[currentAttrName]) {
            elementsWithAttribute[i].parentNode.removeChild(elementsWithAttribute[i])
          }
        }
        for (const [key, value] of Object.entries(extConfigStack)) {
          // 创建一个新元素  
          const newElement = doc.createElement('package');
          newElement.setAttribute('name',key)
          for (const [vKey,vValue] of Object.entries(value)) {
            if (vKey !== 'name') {
              // 为新元素设置属性
              newElement.setAttribute(vKey, vValue);
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
      }})))
    .pipe(dest('temp'));
}

function mergeToMagicWindowSettingConfig() {
  return src('temp/embedded_rules_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(isNeedExtConfig,gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        // 获取根节点  
        const packageConfigNode = doc.getElementsByTagName('package_config')[0]
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const currentAttrName = elementsWithAttribute[i].getAttribute('name')
          if (extConfigStack[currentAttrName]) {
            elementsWithAttribute[i].parentNode.removeChild(elementsWithAttribute[i])
          }
        }
        for (const [key, value] of Object.entries(extConfigStack)) {
          // 创建一个新元素  
          const newElement = doc.createElement('package');
          newElement.setAttribute('name',key)
          for (const [vKey,vValue] of Object.entries(value)) {
            if (vKey !== 'name') {
              // 为新元素设置属性
              newElement.setAttribute(vKey, vValue);
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
      }})))
    .pipe(dest('temp'));
}

function mergeToMagicWindowApplicationListConfig() {
  return src('temp/embedded_rules_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(isNeedExtConfig,gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        // 获取根节点  
        const packageConfigNode = doc.getElementsByTagName('package_config')[0]
        const elementsWithAttribute = doc.getElementsByTagName('package');
        for (let i = 0; i < elementsWithAttribute.length; i++) {
          const currentAttrName = elementsWithAttribute[i].getAttribute('name')
          if (extConfigStack[currentAttrName]) {
            elementsWithAttribute[i].parentNode.removeChild(elementsWithAttribute[i])
          }
        }
        for (const [key, value] of Object.entries(extConfigStack)) {
          // 创建一个新元素  
          const newElement = doc.createElement('package');
          newElement.setAttribute('name',key)
          for (const [vKey,vValue] of Object.entries(value)) {
            if (vKey !== 'name') {
              // 为新元素设置属性
              newElement.setAttribute(vKey, vValue);
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
      }})))
    .pipe(dest('temp'));
}


// const mergeActivityEmbedding = gulpIf(isUseActivityEmbedding,mergeToActivityEmbeddingConfig)

// const mergeMagicWindow = gulpIf(isUseMagicWindow,mergeToMagicWindowSettingConfig,mergeToMagicWindowApplicationListConfig)



module.exports = {
  mergeHwConfig: getHwMagicWindowConfigData,
  mergeOPPOConfig: getOPPOMagicWindowConfigData
  // mergeOPPOConfig: series(getOPPOMagicWindowConfigData,mergeActivityEmbedding,mergeMagicWindow)
}