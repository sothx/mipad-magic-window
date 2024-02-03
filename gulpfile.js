const { series, parallel, task, src } = require('gulp');
const delDist = require('./tasks/delDist');
const buildTemplate = require('./tasks/buildTemplate');
const integrateConfig = require('./tasks/integrateConfig');
const buildRelease = require('./tasks/buildRelease');
const jsonToProp = require('./tasks/jsonToProp');

const buildTasks = series(
  delDist,
  buildTemplate,
  integrateConfig,
  jsonToProp
)

exports.build = buildTasks

const releaseTasks = series(
  buildTasks,
  buildRelease
);

exports.release = releaseTasks