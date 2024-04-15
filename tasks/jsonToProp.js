const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const through = require('through2');
const gulpIf = require('gulp-if');
const gulpJSONEdit = require('gulp-json-editor');
const { options } = require('../config/process.env');

const buildActionIsPad = function () {
  const use_platform = options.use_platform
  return use_platform === 'pad'
}


const buildActionIsTransplant = function () {
  const is_transplant = options.is_transplant
  const is_pad = options.use_platform === 'pad'
  return is_transplant && is_pad
}

const buildActionIsFold = function () {
  const use_platform = options.use_platform
  return use_platform === 'fold'
}

const buildActionIsPad6SPro = function () {
  const use_ratio = options.use_ratio
  return use_ratio === '3:2'
}


const buildActionIsNoShowDivider = function () {
  const use_compatibility = options.use_compatibility
  return use_compatibility === 'not-dragable'
}

const buildActionIsMagicWindow = function () {
  const use_mode = options.use_mode
  return options.use_mode === 'magicWindow'
}


function transformKeyValue(key, value) {
  return `${key}=${value}`;
}

module.exports = function jsonToProp() {
  return src('config/module.config.json')
    .pipe(gulpJSONEdit(function (json) {
      const jsonName = `${options.is_transplant ? 'transplant' : options.use_platform}${options.use_ext ? `-ext` : ''}${options.use_mode === 'magicWindow' ? '-magicWindow' : ''}${options.use_ratio === '3:2' ? '-ratioOf3To2' : ''}${options.use_compatibility ? `${'-' + options.use_compatibility}` : ''}.json`
      if (!options.use_ext) {
        json.updateJson += jsonName
      }
      if (options.use_ext && options.netdisk_desc === 'sothx') {
        json.updateJson += jsonName
      }
      return json;
    }))
    .pipe(gulpIf(buildActionIsFold, gulpJSONEdit(function (json) {
      json.description = `适用于HyperOS For Pad/Fold，用于扩展平行视界的支持范围，以及优化平行视界的体验。当前刷入的是[小米折叠屏通用版]。遇到问题先看[问题合集]，反馈问题请提交[应用名]、[系统版本]、[模块版本]、[不适配的现象]。(反馈应用适配问题可前往酷安私信 @做梦书 或者GitHub:https://github.com/sothx/mipad-magic-window，如需卸载模块请使用GitHub上的卸载模块进行卸载)`;
      return json;
    })))
    .pipe(gulpIf(buildActionIsTransplant, gulpJSONEdit(function (json) {
      json.description = `适用于MIUI 14 For Pad，用于扩展平行视界的支持范围，以及优化平行视界的体验。当前刷入的是[小米平板6Max移植包专版]。遇到问题先看[问题合集]，反馈问题请提交[应用名]、[系统版本]、[模块版本]、[不适配的现象]。(反馈应用适配问题可前往酷安私信 @做梦书 或者GitHub:https://github.com/sothx/mipad-magic-window，如需卸载模块请使用GitHub上的卸载模块进行卸载)`;
      return json;
    })))
    .pipe(gulpIf(buildActionIsPad6SPro, gulpJSONEdit(function (json) {
      json.description = `适用于HyperOS For Pad/Fold，用于扩展平行视界的支持范围，以及优化平行视界的体验。当前刷入的是[小米平板6S Pro专版]。遇到问题先看[问题合集]，反馈问题请提交[应用名]、[系统版本]、[模块版本]、[不适配的现象]。(反馈应用适配问题可前往酷安私信 @做梦书 或者GitHub:https://github.com/sothx/mipad-magic-window，如需卸载模块请使用GitHub上的卸载模块进行卸载)`;
      return json;
    })))
    .pipe(gulpIf(buildActionIsNoShowDivider, gulpJSONEdit(function (json) {
      json.description = `适用于HyperOS For Pad/Fold，用于扩展平行视界的支持范围，以及优化平行视界的体验。当前刷入的是[小米平板安卓13专版]。遇到问题先看[问题合集]，反馈问题请提交[应用名]、[系统版本]、[模块版本]、[不适配的现象]。(反馈应用适配问题可前往酷安私信 @做梦书 或者GitHub:https://github.com/sothx/mipad-magic-window，如需卸载模块请使用GitHub上的卸载模块进行卸载)`;
      return json;
    })))
    .pipe(gulpIf(buildActionIsMagicWindow, gulpJSONEdit(function (json) {
      json.description = `适用于HyperOS For Pad/Fold，用于扩展平行视界的支持范围，以及优化平行视界的体验。当前刷入的是[小米平板安卓11专版]。遇到问题先看[问题合集]，反馈问题请提交[应用名]、[系统版本]、[模块版本]、[不适配的现象]。(反馈应用适配问题可前往酷安私信 @做梦书 或者GitHub:https://github.com/sothx/mipad-magic-window，如需卸载模块请使用GitHub上的卸载模块进行卸载)`;
      return json;
    })))
    .pipe(through.obj((file, enc, cb) => {
      const json = JSON.parse(file.contents.toString());
      const keyValues = Object.keys(json).map(key => {
        const value = json[key];
        return transformKeyValue(key, value);
      }).join('\n');
      if (file.isBuffer()) {
        file.contents = Buffer.from(keyValues);
        cb(null, file);
      }
    }))
    .pipe(gulpRename('module.prop'))
    .pipe(dest('dist'))
}
