const { series, parallel, task, src } = require('gulp');
const { cleanDist, cleanTemp, cleanOutputTemp } = require('./tasks/cleanDir');
const buildTemplate = require('./tasks/buildTemplate');
const integrateConfig = require('./tasks/integrateConfig');
const buildRelease = require('./tasks/buildRelease');
const buildUpdateMsg = require('./tasks/buildUpdateMsg');
const copyChangelog = require('./tasks/copyChangelog');
const jsonToProp = require('./tasks/jsonToProp');
const buildEjsTemplate = require('./tasks/buildEjsTemplate');
const adaptivePlatformToFold = require('./tasks/adaptivePlatformToFold');
const buildExtConfig = require('./tasks/buildExtConfig');
const buildCompatibilityExtends = require('./tasks/buildCompatibilityExtends')
const { mergeActivityEmbeddingConfig, mergeMagicWindowConfig, mergeOrientationConfig } = require('./tasks/mergeMagicWindowConfig');
const buildApplicationCount = require('./tasks/buildApplicationCount');
const buildNetdiskRelease = require('./tasks/buildNetdiskRelease');
const adaptiveCompatibilityToNoDivider = require('./tasks/adaptiveCompatibilityToNoDivider');
const { options } = require('./config/process.env');
const gulpIf = require('gulp-if');


const buildTasks = series(
  cleanDist,
  cleanTemp,
  buildTemplate,
  buildEjsTemplate,
  adaptivePlatformToFold,
  adaptiveCompatibilityToNoDivider,
  buildExtConfig,
  buildApplicationCount,
  integrateConfig,
  buildCompatibilityExtends,
  jsonToProp
)

exports.build = buildTasks


exports.release = buildRelease

const packageTasks = series(buildTasks, buildRelease,buildUpdateMsg,copyChangelog)

exports.package = packageTasks


exports.mergeActivityEmbeddingConfig = mergeActivityEmbeddingConfig

exports.mergeMagicWindowConfig = mergeMagicWindowConfig

exports.mergeOrientationConfig = mergeOrientationConfig


exports.buildNetdiskRelease = buildNetdiskRelease