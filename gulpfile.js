const { series, parallel, task, src } = require('gulp');
const delDist = require('./tasks/delDist');
const buildTemplate = require('./tasks/buildTemplate');
const {integrateConfig} = require('./tasks/integrateConfig');

exports.default = series(
  delDist,
  buildTemplate,
  integrateConfig
)
