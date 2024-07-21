const minimist = require("minimist");

// 配置命令行可以接受的参数以及默认值
let knownOptions = {
  string: ['use_platform','use_ratio','use_mode','use_compatibility','netdisk_desc','module_update_version','last_module_update_version','module_version_interface'],
  boolean: ['use_ext'],
  default: {
    use_platform: "pad", // 平板则为pad，大折叠屏则为fold，小折叠屏为flip
    use_ext: false,// true为混入扩展配置，false则不混入扩展配置
    use_ratio: '16:10', // 模块适配比例，6pro及以下是16:10, 6s pro以上是3:2
    use_mode: 'activityEmbedding', // 使用的平行视界模式，支持安卓11时代的magicWindow和安装12L起的activityEmbedding
    use_merge_config_brand: 'hw', // 合并平行视界规则时候使用的规则厂商品牌，hw——华为/荣耀平板，oppo——OPPO Pad
    use_compatibility: '', // 特别版本的兼容参数，not-dragable——不支持左右滑动条的机型,hyperos-based-on-tiramisu——基于Android 13的 Hyper OS,transplant-6max-based-on-tiramisu——基于Android 13的 6 Max移植包，pipa-for-hyperos——基于Hyper OS的小米平板6
    netdisk_desc: '', // 打包网盘提供的额外参数
    last_module_update_version: '', // 上个需要维护的升级服务版本
    module_update_version: 'V2', // 模块升级服务版本
    module_version_interface: 'standard' // 模块版本，standard 正式版，beta 测试版
  },
  alias: {
    p: 'use_platform',
    e: 'use_ext',
    r: 'use_ratio',
    m: 'use_mode',
    b: 'use_merge_config_brand',
    pc: 'use_compatibility',
  }
};

const options = minimist(process.argv.slice(2), knownOptions);

module.exports = {
  options
}