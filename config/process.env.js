const minimist = require("minimist");

// 配置命令行可以接受的参数以及默认值
let knownOptions = {
  string: ['use_platform'],
  default: {
    use_platform: "pad" // 平板则为pad，折叠屏则为fold
  },
  alias: {
    p: 'use_platform'
  }
};

const options = minimist(process.argv.slice(2), knownOptions);

module.exports = {
  options
}