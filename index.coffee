_ = require 'lodash'
needle = require 'needle'
Promise = require 'bluebird'
xpathStream = require 'xpath-stream'
{format, parse, URLSearchParams} = require 'url'

get = (url) ->
  needle.get url, parse_response: false

cmd = (opts) ->
  url = parse 'http://192.168.1.254'
  url.query = _.defaults custom: 1, opts
  get format url

text = (stream, path) ->
  new Promise (resolve, reject) ->
    stream
      .on 'err', reject
      .pipe xpathStream path
      .on 'data', resolve
      .on 'error', reject

status = (stream) ->
  text stream, '//Status/text()'

module.exports =
  video:
    recStart: ->
      msg = 
        '0': 'Video recording is now started, or is already started.'
        '-11': 'Recording start failed: there\'s not enough space on MicroSD card to start video recording.'
        '-13': 'Recording start failed: the camera is not in video recording mode.'
        '-22': 'Recording start failed: there\'s no MicroSD card in the camera.'
      res = await status cmd 
        cmd: 2001
        par: 1
      msg[res]
    recStop: ->
      msg =
        '0': 'Video recording is now stopped, or is already stopped.'
        '-13': 'The camera is not in video recording mode.'
        '-22': 'There\'s no MicroSD card in the camera.'
      res = await status cmd
        cmd: 2001
        par: 0
      msg[res]
  photo:
    shoot: ->
      msg =
        '0': 'A photo is shot and saved.'
        '-13': 'Shooting failed: the camera is not in photo shooting mode.'
        '-22': 'Shooting failed: there\'s no MicroSD card in the camera.'
      res = await status cmd
        cmd: 1001
      msg[res]
    timelapseShoot:
      start: ->
        msg =
          '0': 'Timelapse photo shooting is started.'
          '-13': 'Shooting start failed: the camera is not in timelapse photo shooting mode.'
          '-22': 'Shooting start failed: there\'s no MicroSD card in the camera.'
        res = await status cmd
          cmd: 1001
        msg[res]
      stop: ->
        msg =
          '0': 'Timelapse photo shooting is stopped.'
          '-13': 'The camera is not in timelapse photo shooting mode.'
          '-22': 'There\'s no MicroSD card in the camera.'
        res = await status cmd
          cmd: 1001
        msg[res]
  camera:
    mode:
      0: 'Photo shooting'
      1: 'Video recording'
      3: 'Timelapse video recording'
      4: 'Timelapse photo shooting'
    item:
      1002: 'photoResolution'
      1006: 'sharpness'
      1007: 'whiteBalance'
      1008: 'colorMode'
      1009: 'iso'
      1011: 'antiShaking'
      1012: 'timelapseInterval'
      2002: 'videoResolution'
      2003: 'loopRecording'
      2004: 'wideDynamic'
      2005: 'exposure'
      2006: 'motionTriggered'
      2007: 'audioRecoding'
      2008: 'timestampOverlay'
      2019: 'timelapseVideoCaptureRate'
      3007: 'autoOffTime'
      3008: 'language'
      3025: 'powerFreq'
    photoResolution:
      0: '4032x3024 (12 megapixels, 4:3)'
      1: '3648x2736 (10 megapixels, 4:3)'
      2: '3264x2448 (8 megapixels, 4:3)'
      3: '2592x1944 (5 megapixels, 4:3)'
      4: '2048x1536 (3 megapixels, 4:3)'
      5: '1920x1080 (2 megapixels, 16:9)'
      6: '640x480 (VGA, 4:3)'
      7: '1280x960 (1.3 megapixels, 16:9)'
    sharpness:
      0: 'Strong'
      1: 'Normal'
      2: 'Smooth'
    whiteBalance:
      0: 'Automatic'
      1: 'Daylight'
      2: 'Cloudy'
      3: 'Tungsten'
      4: 'Fluorescent'
    colorMode:
      0: 'Color'
      1: 'Black and white'
      2: 'Sepia'
    iso:
      0: 'Automatic'
      1: '100'
      2: '200'
      3: '400'
    antiShaking:
      0: 'Disabled'
      1: 'Enabled'
    timelapseInterval:
      0: 'Shoot once every 3 seconds'
      1: 'Shoot once every 5 seconds'
      2: 'Shoot once every 10 seconds'
      3: 'Shoot once every 20 seconds'
    videoResolution:
      0: '1920x1080 at 30 FPS'
      1: '1280x720 at 60 FPS'
      2: '1280x720 at 30 FPS'
      3: '848x480 at 60 FPS'
      4: '640x480 at 60 FPS'
    loopRecording:
      0: 'Disabled'
      1: 'Enabled, 3 minute per chunk'
      2: 'Enabled, 5 minute per chunk'
      3: 'Enabled, 10 minute per chunk'
    wideDynamic:
      0: 'Disabled'
      1: 'Enabled'
    exposure:
      0: '+2.0'
      1: '+5/3'
      2: '+4/3'
      3: '+1.0'
      4: '+2/3'
      5: '+1/3'
      6: '0.0'
      7: '-1/3'
      8: '-2/3'
      9: '-1.0'
      10: '-4/3'
      11: '-5/3'
      12: '-2.0'
    motionTriggered:
      0: 'Disabled'
      1: 'Enabled'
    audioRecording:
      0: 'Disabled'
      1: 'Enabled'
    timestampOverlay:
      0: 'Disabled'
      1: 'Enabled'
    timelapseVideoCaptureRate:
      0: '1 second/frame'
      1: '2 second/frame'
      2: '5 second/frame'
      3: '10 second/frame'
      4: '30 second/frame'
      5: '60 second/frame'
    autoOffTime:
      0: 'Do not automatically turn off on inactivity.'
      1: 'Turn off after 3-minute inactivity.'
      2: 'Turn off after 5-minute inactivity.'
      3: 'Turn off after 10-minute inactivity.'
    language:
      0: 'English'
      1: 'French'
      2: 'Spanish'
      3: 'Polish'
      4: 'German'
      5: 'Italian'
      6: 'Simplified Chinese'
      7: 'Traditional Chinese'
      8: 'Russian'
      9: 'Japanese'
      10: 'Korean'
      11: 'Hebrew'
      12: 'Portuguese'
    powerFreq:
      0: '50 Hz'
      1: '60 Hz'
    config:
      get: (raw=false) ->
        new Promise (resolve, reject) ->
          cmd cmd: 3014
            .on 'err', reject
            .pipe xpathStream '(//Cmd | //Status)/text()'
            .on 'data', (res) ->
              res = for item, i in res by 2
                stat = res[i + 1]
                [item, stat]
              if not raw
                res = for [item, stat] in res
                  item = module.exports.camera.item[item] || item
                  if module.exports.camera[item]?
                    stat = module.exports.camera[item][stat]
                  [item, stat]
              resolve res
            .on 'error', reject
      set: (item, val) ->
        item = (_.invert module.exports.camera.item)[item] || item
        await status cmd
          cmd: item
          par: val
        res = await module.exports.camera.config.get true
        res = _.find res, ([i, stat]) ->
          item.toString() == i
        item = module.exports.camera.item[item] || item
        module.exports.camera[item][res[1]]
    switch: (mode) ->
      res = await status cmd
        cmd: 3001
        par: mode
    currMode: ->
      res = await status cmd
        cmd: 3016
      module.exports.camera.mode[res]
    photoShoot: ->
      module.exports.camera.switch 0
    videoRec: ->
      module.exports.camera.switch 1
    timelapseVideoRec: ->
      module.exports.camera.switch 3
    timelapsePhotoShoot: ->
      module.exports.camera.switch 4
