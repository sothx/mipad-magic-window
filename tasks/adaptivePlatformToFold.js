const gulpEjs = require('gulp-ejs');
const gulpRename = require('gulp-rename');
const { src, dest } = require('gulp');
const { options } = require('../config/process.env');

/**
 * 折叠屏设备不适配splitRatio参数，统一去除
 */
module.exports = function adaptivePlatformToFold() {

}