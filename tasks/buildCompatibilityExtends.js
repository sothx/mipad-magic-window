const { src, dest } = require('gulp');
const { options } = require('../config/process.env');
const gulpIf = require('gulp-if');
const fs = require('fs')

const distDir = 'dist'
const moduleSrc = 'module_src'

const getCompatibilityAction = function () {
  const use_compatibility = options.use_compatibility
  return use_compatibility
}

const path = `${moduleSrc}/module_compatibility_extends/${getCompatibilityAction()}`


module.exports = function buildCompatibilityExtends(cb) {
    try {
        const pathNotEmpty = fs.readdirSync(path)
        if (pathNotEmpty) {
            return src(`${path}/**/*`) // 指定路径
            .pipe(dest(`${distDir}`))
        }
    } catch (err) {
        cb()
    }
}