const del = require('del');


const cleanDist = function (cb) {
  return del('dist').then(() => {
    cb()
  })
}


const cleanTemp = function (cb) {
  return del('temp').then(() => {
    cb()
  })
}

const cleanOutputTemp = function (cb) {
  return del('output_temp').then(() => {
    cb()
  })
}


module.exports = {
  cleanDist,
  cleanTemp,
  cleanOutputTemp
}