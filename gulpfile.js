const { series, parallel, task, src } = require('gulp');
const delDist = require('./tasks/delDist');
const buildTemplate = require('./tasks/buildTemplate');
const integrateConfig = require('./tasks/integrateConfig');
const buildrelease = require('./tasks/buildrelease');
const jsonToProp = require('./tasks/jsonToProp');

const buildTasks = series(
  delDist,
  buildTemplate,
  integrateConfig,
  jsonToProp
)

exports.build = buildTasks


exports.release = buildrelease

const publishTasks = series(build, buildrelease)

exports.publish = publishTasks