const minimist = require("minimist");

// 配置命令行可以接受的参数以及默认值
let knownOptions = {
  string: ['use_platform'],
  boolean: ['use_ext', 'is_transplant', 'use_ratio'],
  default: {
    use_platform: "pad", // 平板则为pad，折叠屏则为fold
    use_ext: false,// true为混入扩展配置，false则不混入扩展配置
    is_transplant: false, // true为基于6max的移植包，false则为非移植包
    use_ratio: '16:10', // 模块适配比例，6pro及以下是16:10, 6s pro以上是3:2
  },
  alias: {
    p: 'use_platform',
    e: 'use_ext',
    t: 'is_transplant',
    r: 'use_ratio'
  }
};

const options = minimist(process.argv.slice(2), knownOptions);

module.exports = {
  options
}