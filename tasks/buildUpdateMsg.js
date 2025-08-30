const { src, dest } = require('gulp');
const gulpJSONEdit = require('gulp-json-editor');
const gulpRename = require('gulp-rename');
const clone = require('gulp-clone');
const through2 = require('through2');

const moduleConfig = require('../config/module.config.json');
const { options } = require('../config/process.env');

const moduleUpdateVersion = options.module_update_version;
const lastModuleUpdateVersion = options.last_module_update_version;

const packageName = `${options.use_platform}${options.use_ext ? '-ext' : ''}${options.use_mode === 'magicWindow' ? '-magicWindow' : ''}${options.use_compatibility ? '-' + options.use_compatibility : ''}`;

const isNeedBuildLastModuleUpdateVersion = () => {
  return lastModuleUpdateVersion !== '';
};

// 专门处理 lastVersion 的 zipUrl
function patchLastVersionZipUrl() {
  return through2.obj(function (file, _, cb) {
    if (file.isBuffer()) {
      const json = JSON.parse(file.contents.toString());

      if (lastModuleUpdateVersion === 'V10' && packageName === 'pad') {
        json.zipUrl = `https://github.com/sothx/mipad-magic-window/releases/download/${moduleConfig.version}/pad-general-vanillaIceCream-${moduleConfig.version}.zip`;
      }

      file.contents = Buffer.from(JSON.stringify(json, null, 2));
    }
    cb(null, file);
  });
}

module.exports = function buildUpdateMsg(cb) {
  const unNeedUpdate = () => {
    if (options.netdisk_desc === 'sothx') return false;
    if (options.use_ext) return true;
    return false;
  };

  if (unNeedUpdate()) return cb();

  // 基础流：生成当前版本的 JSON
  const baseStream = src('module_src/template/release.json')
    .pipe(
      gulpJSONEdit(json => {
        json.version = moduleConfig.version;
        json.versionCode = Number(moduleConfig.versionCode);
        json.zipUrl = `https://github.com/sothx/mipad-magic-window/releases/download/${moduleConfig.version}/${packageName}-${moduleConfig.version}.zip`;
        json.changelog = `https://hyper-magic-window-module-update.sothx.com/release/${moduleUpdateVersion}/changelog.md`;
        json.chinaMobileMCloudUrl = `https://caiyun.139.com/m/i?135CdgGlXeVEC`;
        return json;
      })
    )
    .pipe(gulpRename(`${packageName}.json`));

  // 如果需要 lastVersion，克隆一份流单独处理
  if (isNeedBuildLastModuleUpdateVersion()) {
    baseStream
      .pipe(clone())
      .pipe(patchLastVersionZipUrl())
      .pipe(dest(`docs/release/${lastModuleUpdateVersion}/`));
  }

  // 当前版本始终输出
  return baseStream.pipe(dest(`docs/release/${moduleUpdateVersion}/`)).on('end', cb);
};
