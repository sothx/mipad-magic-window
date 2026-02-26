const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest, parallel, series } = require('gulp');
const { options } = require('../config/process.env');
const gulpXML = require('gulp-xml');
const gulpIf = require('gulp-if');
const DOMParser = require('xmldom').DOMParser;
const XMLSerializer = require('xmldom').XMLSerializer;

const buildActionIsOS3Pad = function () {
  const use_platform = options.use_platform;
  const use_mode = options.use_mode;
  const mi_os_version = options.mi_os_version;
  return use_platform === 'pad' && use_mode === 'activityEmbedding' && mi_os_version >= 3;
}

let EMStack = {}


/**
 * 小米平板 Hyper OS 3.0 适配优化
 */


function adaptiveFO(cb) {
  return src('temp/fixed_orientation_list.xml') // 指定XML文件的路径
    .pipe(gulpIf(buildActionIsOS3Pad, gulpXML({
      callback: function (result) {
        const doc = new DOMParser().parseFromString(result, 'text/xml');
        const elementsWithAttribute = doc.getElementsByTagName('package');

        for (let i = elementsWithAttribute.length - 1; i >= 0; i--) {
          const packageElement = elementsWithAttribute[i];
          const ratio = packageElement.getAttribute('ratio');
          const compatChange = packageElement.getAttribute('compatChange') || '';

          if (!ratio) continue;

          const ratioNum = Number(ratio);

          if (ratioNum >= 1.5 && ratioNum <= 1.7) {
            const compatSet = new Set(
              compatChange.split(',').map(v => v.trim()).filter(Boolean)
            );

            [
              'OVERRIDE_MIN_ASPECT_RATIO',
              'OVERRIDE_MIN_ASPECT_RATIO_EXCLUDE_PORTRAIT_FULLSCREEN',
              'OVERRIDE_MIN_ASPECT_RATIO_MEDIUM'
            ].forEach(v => compatSet.add(v));

            packageElement.setAttribute('compatChange', Array.from(compatSet).join(','));
          }

          if (ratioNum > 1.7 && ratioNum <= 1.99) {
            const compatSet = new Set(
              compatChange.split(',').map(v => v.trim()).filter(Boolean)
            );

            [
              'OVERRIDE_MIN_ASPECT_RATIO',
              'OVERRIDE_MIN_ASPECT_RATIO_EXCLUDE_PORTRAIT_FULLSCREEN',
              'OVERRIDE_MIN_ASPECT_RATIO_LARGE'
            ].forEach(v => compatSet.add(v));

            packageElement.setAttribute('compatChange', Array.from(compatSet).join(','));
          }

          // 删除 ratio 属性
          packageElement.removeAttribute('ratio');
        }

        return new XMLSerializer().serializeToString(doc).replace(/\/>/g, ' />');
      }
    })))
    .pipe(dest('temp'))
    .on('end', cb);
}

module.exports = series(adaptiveFO)