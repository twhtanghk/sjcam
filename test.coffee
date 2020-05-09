{camera} = require './index'

camera.config
  .get()
  .then console.log, console.error

camera.config
  .set 'videoResolution', 0
  .then console.log, console.error

