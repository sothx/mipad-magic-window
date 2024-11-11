const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const through = require('through2');
const gulpIf = require('gulp-if');
const gulpJSONEdit = require('gulp-json-editor');
const { options } = require('../config/process.env');

const moduleUpdateVersion = options.module_update_version

const buildActionIsPad = function () {
  const use_platform = options.use_platform
  return use_platform === 'pad'
}

const buildActionIsPhone = function () {
  const use_platform = options.use_platform
  return use_platform === 'phone'
}


const buildActionIsYudiDeviceCode = function () {
  const is_transplant = options.use_compatibility === 'yudi-device-code'
  const is_pad = options.use_platform === 'pad'
  return is_transplant && is_pad
}

const buildActionIsFold = function () {
  const use_platform = options.use_platform
  return use_platform === 'fold'
}

const buildActionIsShengDeviceCode = function () {
  const use_compatibility = options.use_compatibility
  return use_compatibility === 'sheng-device-code'
}


const buildActionIsGeneralUpsideDownCake = function () {
  const use_compatibility = options.use_compatibility
  return use_compatibility === 'general-upsideDownCake'
}


const buildActionIsGeneralTiramisu = function () {
  const use_compatibility = options.use_compatibility
  return use_compatibility === 'general-tiramisu'
}

const buildActionIsHyperOSBasedOnTiramisu = function () {
  const use_compatibility = options.use_compatibility
  return use_compatibility === 'hyperos-based-on-tiramisu'
}

const buildActionIsMIUIBasedOnTiramisu = function () {
  const use_compatibility = options.use_compatibility
  return use_compatibility === 'miui-based-on-tiramisu'
}

const buildActionIsPipaDeviceCode = function () {
  const use_compatibility = options.use_compatibility
  return use_compatibility === 'pipa-device-code'
}

const buildActionIsHyperOS1BasedOnUpsideDownCake = function () {
  const use_compatibility = options.use_compatibility
  return use_compatibility === 'hyperos1-based-on-upsideDownCake'
}

const buildActionIsDaguDeviceCode = function () {
  const use_compatibility = options.use_compatibility
  return use_compatibility === 'dagu-device-code'
}

const buildActionIsMagicWindow = function () {
  const use_mode = options.use_mode
  return use_mode === 'magicWindow'
}

const buildActionIsSothx = function () {
  const is_pad = options.use_platform === 'pad'
  const is_sothx = options.netdisk_desc === 'sothx'

  return is_pad && is_sothx
}


function transformKeyValue(key, value) {
  return `${key}=${value}`;
}

const moduleType = `${options.use_platform}${options.use_ext ? `-ext` : ''}${options.use_mode === 'magicWindow' ? '-magicWindow' : ''}${options.use_compatibility ? `${'-' + options.use_compatibility}` : ''}`

module.exports = function jsonToProp(cb) {
  return src('config/module.config.json')
    .pipe(gulpJSONEdit(function (json) {
      /** 配置更新链接 */
      const jsonName = `${moduleUpdateVersion}/${moduleType}.json`
      if (!options.use_ext) {
        json.updateJson += jsonName
      }
      if (options.use_ext && options.netdisk_desc === 'sothx') {
        // const ignoreExtModuleType = `${options.use_platform}${options.use_mode === 'magicWindow' ? '-magicWindow' : ''}${options.use_ratio === '3:2' ? '-ratioOf3To2' : ''}${options.use_compatibility ? `${'-' + options.use_compatibility}` : ''}`
        json.updateJson += `${moduleUpdateVersion}/${moduleType}.json`
        // json.updateJson += jsonName
      }
      /** 配置版本号 */
      json.version = `${moduleType}-${json.version}.${options.module_version_interface}`
      return json;
    }))
    .pipe(gulpIf(buildActionIsPad, gulpJSONEdit(function (json) {
      json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}，仅兼容Android 15+]` : ''} 适用于HyperOS For Pad，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[小米平板安卓15测试(Beta)版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，如需卸载模块请移除模块后重启平板)`;
      return json;
    })))
    .pipe(gulpIf(buildActionIsPhone, gulpJSONEdit(function (json) {
      json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}，仅兼容Android 15+]` : ''} 适用于HyperOS For Phone，用于扩展妙享桌面的支持范围并优化适配体验，。当前刷入的是[小米手机妙享桌面版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，如需卸载模块请移除模块后重启平板)`;
      return json;
    })))
    .pipe(gulpIf(buildActionIsGeneralUpsideDownCake, gulpJSONEdit(function (json) {
      json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}，仅兼容Android 14]` : ''} 适用于HyperOS For Pad，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[小米平板安卓14通用版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，如需卸载模块请移除模块后重启平板)`;
      return json;
    })))
    .pipe(gulpIf(buildActionIsFold, gulpJSONEdit(function (json) {
      json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}]` : ''} 适用于HyperOS For Fold，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[小米折叠屏通用版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，如需卸载模块请移除模块后重启平板)`;
      return json;
    })))
    // .pipe(gulpIf(buildActionIsYudiDeviceCode, gulpJSONEdit(function (json) {
    //   json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}，仅兼容Android 13]` : ''} 适用于MIUI 14 For Pad，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[小米平板6Max(yudi)澎湃专版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，本模块仅适用于基于MIUI14 For Pad的 6 Max 移植包，移植包升级Hyper OS For Pad之前，请先卸载本模块，如需卸载模块请移除模块后重启平板)`;
    //   return json;
    // })))
    .pipe(gulpIf(buildActionIsHyperOSBasedOnTiramisu, gulpJSONEdit(function (json) {
      json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}，仅兼容Android 13]` : ''} 适用于HyperOS For Pad，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[小米平板5系列安卓13澎湃专版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，本模块仅适用于小米平板5、小米平板5 Pro和小米平板5 Pro 5G 的小米官方 Hyper OS For Pad，升级系统前请先卸载本模块，避免卡米，如需卸载模块请移除模块后重启平板)`;
      return json;
    })))
    .pipe(gulpIf(buildActionIsMIUIBasedOnTiramisu, gulpJSONEdit(function (json) {
      json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}，仅兼容Android 13]` : ''} 适用于MIUI14 For Pad，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[小米平板6系列MIUI14专版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，本模块仅适用于小米平板6/6 Pro/6 Max/5 Pro 12.4的小米官方 MIUI14 For Pad，升级系统前请先卸载本模块，避免卡米，如需卸载模块请移除模块后重启平板)`;
      return json;
    })))
    // .pipe(gulpIf(buildActionIsPipaDeviceCode, gulpJSONEdit(function (json) {
    //   json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}，仅兼容Android 14,未兼容Android 15]` : ''} 适用于HyperOS For Pad，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[小米平板6(pipa)澎湃专版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，本模块仅适用于小米平板6(pipa) 的小米官方 Hyper OS For Pad，升级系统前请先卸载本模块，避免卡米，如需卸载模块请移除模块后重启平板)`;
    //   return json;
    // })))
    .pipe(gulpIf(buildActionIsHyperOS1BasedOnUpsideDownCake, gulpJSONEdit(function (json) {
      json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}，仅兼容Android 14]` : ''} 适用于HyperOS For Pad 1.0，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[小米平板安卓14澎湃1.0专版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，本模块仅适用于小米平板6/6S Pro/6 Max/6 Pro/5 Pro 12.4的小米官方基于 Android 14 的 Hyper OS For Pad 1.0，升级系统前请先卸载本模块，避免卡米，如需卸载模块请移除模块后重启平板)`;
      return json;
    })))
    // .pipe(gulpIf(buildActionIsDaguDeviceCode, gulpJSONEdit(function (json) {
    //   json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}，仅兼容Android 14,未兼容Android 15]` : ''} 适用于HyperOS For Pad，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[小米平板5 Pro 12.4(dagu)澎湃专版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，本模块仅适用于小米平板5 Pro 12.4(dagu) 的小米官方 Hyper OS For Pad，升级系统前请先卸载本模块，避免卡米，如需卸载模块请移除模块后重启平板)`;
    //   return json;
    // })))
    // .pipe(gulpIf(buildActionIsShengDeviceCode, gulpJSONEdit(function (json) {
    //   json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}，仅兼容Android 14,未兼容Android 15]` : ''} 适用于HyperOS For Pad，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[小米平板6S Pro(sheng)澎湃专版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，本模块仅适用于小米平板6S Pro(sheng) 的小米官方 Hyper OS For Pad，升级系统前请先卸载本模块，避免卡米，如需卸载模块请移除模块后重启平板)`;
    //   return json;
    // })))
    .pipe(gulpIf(buildActionIsGeneralTiramisu, gulpJSONEdit(function (json) {
      json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}，完全兼容Android 13,部分兼容Android 12]` : ''} 适用于MIUI 14 For Pad，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[小米平板安卓13通用版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，如需卸载模块请移除模块后重启平板)`;
      return json;
    })))
    .pipe(gulpIf(buildActionIsMagicWindow, gulpJSONEdit(function (json) {
      json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}，仅兼容Android 11]` : ''} 适用于MIUI 12.5 For Pad，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[小米平板安卓11通用版]。(反馈应用适配问题可前往酷安私信 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，如需卸载模块请移除模块后重启平板)`;
      return json;
    })))
    .pipe(gulpIf(buildActionIsSothx, gulpJSONEdit(function (json) {
      json.description = `${global.applicationRuleCount ? `[★适配应用总数:${global.applicationRuleCount}]` : ''} 适用于HyperOS For Pad，用于扩展应用横屏布局、应用布局优化和游戏显示布局的支持范围并优化适配体验，支持[自定义规则]扩充或覆盖部分应用适配。当前刷入的是[自用版]，此版本仅供模块作者使用，含有大量测试用途的代码，误装容易造成卡米。(下载正式版可前往酷安动态 @做梦书 ，模块首页:https://hyper-magic-window.sothx.com，GitHub仓库:https://github.com/sothx/mipad-magic-window，模块Q群:277757185，如需卸载模块请移除模块后重启平板)`;
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
    .on('end', cb);
}
