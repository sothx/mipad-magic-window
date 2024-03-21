module.exports = function buildCustomConfig(cb) {
  return src('../custom_config_template/**/**')
    .pipe(gulpzip(`custom_config_template_0.00.00.zip`))
    .pipe(dest(`release/${moduleConfig.version}`))
}