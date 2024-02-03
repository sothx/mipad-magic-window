const del = require('del');
module.exports = function clean(cb) {
  return del('dist').then(() => {
    cb()
  })
};