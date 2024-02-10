const minimist = require("minimist");

// 配置命令行可以接受的参数以及默认值
let knownOptions = {
  string: ['use_platform'],
  boolean: ['use_ext'],
  default: {
    use_platform: "pad", // 平板则为pad，折叠屏则为fold
    use_ext: false,// true为混入扩展配置，false则不混入扩展配置
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