const minimist = require("minimist");

// 配置命令行可以接受的参数以及默认值
let knownOptions = {
  string: ['use_platform'],
  boolean: ['use_ext','is_migration'],
  default: {
    use_platform: "pad", // 平板则为pad，折叠屏则为fold
    use_ext: false,// true为混入扩展配置，false则不混入扩展配置
    is_migration: false, // true为基于6max的移植包，false则为非移植包
  },
  alias: {
    p: 'use_platform',
    e: 'use_ext'
  }
};

const options = minimist(process.argv.slice(2), knownOptions);

module.exports = {
  options
}