lp = require('../lib/launchpad')()

noiseDemo = ->
  for x in [0...8]
    for y in [0...8]
      red   = ~~(Math.random()*4)
      green = ~~(Math.random()*4)
      lp.set x,y,red,green

setInterval noiseDemo, 100
