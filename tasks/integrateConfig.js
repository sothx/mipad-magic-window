const { src, dest, parallel, series } = require('gulp');
const { cleanTemp } = require('./cleanDir');
const gulpXML = require('gulp-xml');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

const moduleSrc = 'module_src'
const tempDir = 'temp'
const commonDist = 'dist/common'
const systemDist = 'dist'

let ruleListStack = {}

/**
 * 混入公共配置
 */

function copyREADME() {
  return src(`README.md`)
    .pipe(dest(`${systemDist}/`))
}

/**
 * 混入Android 12L 起的平行窗口配置
 */

function copyOriginEmbeddedRuleListToCommon() {
  return src(`${moduleSrc}/embedded_rules_list_bak`)
    .pipe(dest(`${commonDist}/product/etc/`))
}


function copyEmbeddedRuleListToCommon() {
  return src(`${tempDir}/embedded_rules_list.xml`)
    .pipe(dest(`${commonDist}/product/etc/`))
}

function copyEmbeddedRuleListToSystem() {
  return src(`${tempDir}/embedded_rules_list.xml`)
    .pipe(dest(`${systemDist}/product/etc/`))
}


/**
 * 生成配置文件
 */

function readEmbeddedRuleList() {
  return src(`${tempDir}/embedded_rules_list.xml`) // 指定XML文件的路径
  .pipe(gulpXML({
    callback: function(result) {
      const doc = new DOMParser().parseFromString(result, 'text/xml');
      const elementsWithAttribute = doc.getElementsByTagName('package');
      // console.log(doc,'doc')
      for (let i = 0; i < elementsWithAttribute.length; i++) {
        const currentAttrName = elementsWithAttribute[i].getAttribute('name')
        if (currentAttrName) {
          ruleListStack[currentAttrName] = {}
          ruleListStack[currentAttrName]['embeddedEnable'] = true
        }
      }
    }
  }))
}


function generateEmbeddedSettingConfig() {
  return src(`${moduleSrc}/embedded_setting_config.xml`) // 指定XML文件的路径
  .pipe(gulpXML({
    callback: function(result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml')
        // 获取根节点  
        const root = doc.documentElement;  
        const packageConfigNode = doc.getElementsByTagName('setting_rule')[0]
        for (const [key, value] of Object.entries(ruleListStack)) {
          // 创建一个新元素  
          const newElement = doc.createElement('setting');
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
    }
  }))
  .pipe(dest('temp'));
}

function copyEmbeddedSettingConfig() {
  return src(`${tempDir}/embedded_setting_config.xml`)
  .pipe(dest(`${commonDist}/system/users/0/`))
}





module.exports = series(parallel(copyREADME,copyOriginEmbeddedRuleListToCommon,copyEmbeddedRuleListToCommon,copyEmbeddedRuleListToSystem,series(readEmbeddedRuleList,generateEmbeddedSettingConfig,copyEmbeddedSettingConfig)),cleanTemp)
