const { src, dest } = require("gulp");
const plumber = require("gulp-plumber");
const { options } = require("../config/process.env");

module.exports = function buildWebUI(cb) {
  if (!options.is_projection && options.use_mode !== "magicWindow") {
    return src("module_src/webroot/**/*", { dot: true }) // 确保返回流
      .pipe(plumber()) // 使用 gulp-plumber 来捕获错误
      .pipe(dest("dist/webroot/"))
      .on("end", cb);
  } else {
    cb(); // 如果条件不满足，直接结束任务
  }
};