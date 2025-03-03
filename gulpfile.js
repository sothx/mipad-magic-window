const { series, parallel, task, src } = require('gulp');
const { cleanDist, cleanTemp, cleanOutputTemp } = require('./tasks/cleanDir');
const buildTemplate = require('./tasks/buildTemplate');
const integrateConfig = require('./tasks/integrateConfig');
const buildRelease = require('./tasks/buildRelease');
const buildUpdateMsg = require('./tasks/buildUpdateMsg');
const copyChangelog = require('./tasks/copyChangelog');
const jsonToProp = require('./tasks/jsonToProp');
const buildEjsTemplate = require('./tasks/buildEjsTemplate');
const adaptiveHyperOS2 = require('./tasks/adaptiveHyperOS2');
const adaptiveHyperOS1 = require('./tasks/adaptiveHyperOS1');
const adaptivePlatformToFold = require('./tasks/adaptivePlatformToFold');
const buildExtConfig = require('./tasks/buildExtConfig');
const buildCompatibilityExtends = require('./tasks/buildCompatibilityExtends')
const buildWebUI = require('./tasks/buildWebUI')
const buildVerifyFunctionExtends = require('./tasks/buildVerifyFunctionExtends')
const { mergeActivityEmbeddingConfig, mergeMagicWindowConfig, mergeOrientationConfig } = require('./tasks/mergeMagicWindowConfig');
const buildApplicationCount = require('./tasks/buildApplicationCount');
const buildNetdiskRelease = require('./tasks/buildNetdiskRelease');
const adaptiveCompatibilityToGeneralTiramisu = require('./tasks/adaptiveCompatibilityToGeneralTiramisu');
const { getEmbeddedRulesListConfig,getFixedOrientationListConfig, mergeMiConfigJsonFiles } = require('./tasks/mergeMiConfig')
const { pkFullRuleConfig, pkDisableConfig, pkEmbeddedConfig } = require('./tasks/pkMiConfig')
const { options } = require('./config/process.env');
const gulpIf = require('gulp-if');


const buildTasks = series(
  cleanDist,
  cleanTemp,
  buildTemplate,
  buildWebUI,
  buildCompatibilityExtends,
  buildVerifyFunctionExtends,
  buildEjsTemplate,
  adaptivePlatformToFold,
  adaptiveHyperOS2,
  adaptiveHyperOS1,
  adaptiveCompatibilityToGeneralTiramisu,
  buildExtConfig,
  buildApplicationCount,
  integrateConfig,
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


/**test */

exports.getEmbeddedRulesListConfig = getEmbeddedRulesListConfig

exports.getFixedOrientationListConfig = getFixedOrientationListConfig

exports.mergeMiConfigJsonFiles = mergeMiConfigJsonFiles

exports.pkFullRuleConfig = pkFullRuleConfig

exports.pkDisableConfig = pkDisableConfig

exports.pkEmbeddedConfig = pkEmbeddedConfig