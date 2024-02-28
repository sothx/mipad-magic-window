const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest, parallel, series } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;
const fs = require('fs')

let extConfigStack = {}


const isNeedExtConfig = function() {
  const use_ext = options.use_ext
  return use_ext;
}

/**
 * 支持扩展应用规则(Only Android 12+)
 */
function getExtConfigData() {
  return src('temp/ext/embedded_rules_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(isNeedExtConfig,gulpXML({
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
    })))
    .pipe(gulpRename({
      extname: '.json'
    }))
    .pipe(dest('temp/json/'))
}

function mergeExtConfig() {
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

module.exports = series(getExtConfigData,mergeExtConfig)