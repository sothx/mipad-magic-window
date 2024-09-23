
const { src, dest, parallel, series } = require('gulp');
const through = require('through2');
const _ = require('lodash');
const gulpRename = require('gulp-rename');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;
const xml2js = require('xml2js');
const fs = require('fs');
const xmlbuilder = require('xmlbuilder');

function processConfigFiles(type, cb) {
  const parser = new xml2js.Parser();
  const xmlFilePath = `input_merge_config/mi_magicwindow_config/${type}_list.xml`;
  const jsonFilePath = `input_merge_config/mi_magicwindow_config/${type}_list.json`;
  
  return src(xmlFilePath)
    .pipe(through.obj((file, enc, cb) => {
      parser.parseString(file.contents.toString(), (err, result) => {
        if (err) {
          return cb(err);
        }
        
        const packages = result.package_config.package; // 获取 package 数组
        const processedJson = _.fromPairs(packages.map(pkg => {
          const name = pkg.$.name; // 获取 name 属性
          const { $, ...rest } = pkg; // 去掉 $，保留其他属性
          return [name, { ...rest, ...$ }]; // 将其他属性和 $ 的内容合并
        }));

        console.log('总适配应用总数', Object.keys(processedJson).length);
        file.contents = Buffer.from(JSON.stringify(processedJson, null, 2));
        cb(null, file);
      });
    }))
    .pipe(gulpRename(`source_${type}_list.json`))
    .pipe(dest('output_temp/json/'))
    .on('end', () => {
      // 处理目标 JSON 文件
      return src(jsonFilePath)
        .pipe(through.obj((file, enc, cb) => {
          let data = JSON.parse(file.contents.toString());
          let json = _.mapValues(_.keyBy(data, 'name'), (value) => _.omit(value, 'name'));
          
          console.log('总适配应用总数', Object.keys(json).length);
          file.contents = Buffer.from(JSON.stringify(json, null, 2));
          cb(null, file);
        }))
        .pipe(gulpRename(`target_${type}_list.json`))
        .pipe(dest('output_temp/json/'))
        .on('end', cb);
    });
}

function getEmbeddedRulesListConfig(cb) {
  processConfigFiles('embedded_rules', cb);
}

function getFixedOrientationListConfig(cb) {
  processConfigFiles('fixed_orientation', cb);
}

function mergeMiConfigJsonFiles(cb) {
  function processFiles(sourceFile, targetFile, outputPrefix) {
    const sourceData = JSON.parse(fs.readFileSync(sourceFile, 'utf8'));
    const targetData = JSON.parse(fs.readFileSync(targetFile, 'utf8'));
    
    const mergedData = {};
    const newEntries = {};
    const warnings = [];

    // 以 targetData 为基础，判断 sourceData 缺少的属性
    for (const [key, targetValue] of Object.entries(targetData)) {
      if (key in sourceData) {
        const sourceValue = sourceData[key];
        
        // 检查 sourceValue 中缺少的属性
        const missingKeys = Object.keys(targetValue).filter(k => !(k in sourceValue));
        if (missingKeys.length > 0) {
          const missingAttributes = missingKeys.map(k => `${k}: ${targetValue[k]}`).join(', ');
          const warningMessage = `包 ${key} 缺少的属性: ${missingAttributes}`;
          warnings.push(warningMessage);
          console.warn(warningMessage);
        }
        
        mergedData[key] = { ...targetValue, ...sourceValue };
      } else {
        // 如果在 sourceData 中不存在的键，则记录为新增内容
        newEntries[key] = targetValue; // 记录新增内容
      }
    }

    // 将 sourceData 中存在但 targetData 中缺失的键添加到末尾
    for (const [key, value] of Object.entries(sourceData)) {
      if (!(key in targetData)) {
        mergedData[key] = value; // 直接添加到合并数据中
      }
    }

    // 输出合并后的 JSON 文件
    fs.writeFileSync(`output_temp/json/${outputPrefix}_merged_output.json`, JSON.stringify(mergedData, null, 2));
    
    // 输出新增内容的 JSON 文件
    fs.writeFileSync(`output_temp/json/${outputPrefix}_new_entries.json`, JSON.stringify(newEntries, null, 2));

    // 生成 XML for mergedData
    const root = xmlbuilder.create('package_config');
    for (const [key, value] of Object.entries(mergedData)) {
      const attributes = { name: key, ...value };
      root.ele('package', attributes);
    }
    fs.writeFileSync(`output_temp/json/${outputPrefix}_merged_output.xml`, root.end({ pretty: true }));

    // 生成 XML for newEntries
    const newEntriesRoot = xmlbuilder.create('package_config');
    for (const [key, value] of Object.entries(newEntries)) {
      const attributes = { name: key, ...value };
      newEntriesRoot.ele('package', attributes);
    }
    fs.writeFileSync(`output_temp/json/${outputPrefix}_new_entries.xml`, newEntriesRoot.end({ pretty: true }));

    // 将警告信息写入 txt 文件
    if (warnings.length > 0) {
      fs.writeFileSync(`output_temp/json/${outputPrefix}_missing_keys_warnings.txt`, warnings.join('\n'), 'utf8');
    }
  }

  // 调用 processFiles 函数，传入需要处理的文件
  processFiles('output_temp/json/source_embedded_rules_list.json', 'output_temp/json/target_embedded_rules_list.json', 'embedded_rules');
  processFiles('output_temp/json/source_fixed_orientation_list.json', 'output_temp/json/target_fixed_orientation_list.json', 'fixed_orientation');

  cb();
}


module.exports = {
  getEmbeddedRulesListConfig,
  getFixedOrientationListConfig,
  mergeMiConfigJsonFiles
}