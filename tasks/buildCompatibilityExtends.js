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


module.exports = async function buildCompatibilityExtends(cb) {

    const use_compatibility = getCompatibilityAction()
    try {
        const pathNotEmpty = fs.readdirSync(path)
        if (pathNotEmpty && use_compatibility) {
            return src(`${path}/**/*`) // 指定路径
            .pipe(dest(`${distDir}`))
        }
    } catch (err) {
        cb()
    }
}