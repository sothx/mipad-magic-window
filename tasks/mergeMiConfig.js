
const { src, dest, parallel, series } = require('gulp');
const through = require('through2');
const _ = require('lodash');
const gulpRename = require('gulp-rename');

let SourceEmbeddedRulesList = {}

let TargetEmbeddedRulesList = {}

let SourceFixedOrientationList= {}

let TargetFixedOrientationList= {}

function getTargetEmbeddedRulesListConfig(cb) {
    OPPOConfigStack = {}
    return src(`input_merge_config/mi_magicwindow_config/embedded_rules_list.json`)
      .pipe(through.obj((file, enc, cb) => {
        let data = JSON.parse(file.contents.toString());
        let json = _.mapValues(_.keyBy(data, 'name'), (value) => _.omit(value, 'name'));
        TargetEmbeddedRulesList = json
        console.log('总适配应用总数',Object.keys(json).length)
        file.contents = Buffer.from(JSON.stringify(json, null, 2));
        cb(null, file);
      }))
      .pipe(gulpRename('target_embedded_rules_list.json'))
      .pipe(dest('output_temp/json/'))
      .on('end', cb);
  }

  function getTargetFixedOrientationListConfig(cb) {
    OPPOConfigStack = {}
    return src(`input_merge_config/mi_magicwindow_config/fixed_orientation_list.json`)
      .pipe(through.obj((file, enc, cb) => {
        let data = JSON.parse(file.contents.toString());
        let json = _.mapValues(_.keyBy(data, 'name'), (value) => _.omit(value, 'name'));
        TargetFixedOrientationList = json
        console.log('总适配应用总数',Object.keys(json).length)
        file.contents = Buffer.from(JSON.stringify(json, null, 2));
        cb(null, file);
      }))
      .pipe(gulpRename('target_fixed_orientation_list.json'))
      .pipe(dest('output_temp/json/'))
      .on('end', cb);
  }

  module.exports = {
    getTargetEmbeddedRulesListConfig,
    getTargetFixedOrientationListConfig
  }