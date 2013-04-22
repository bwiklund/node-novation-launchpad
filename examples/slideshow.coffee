lp = require('../lib/launchpad')()

time = 0

noiseDemo = ->
  for x in [0...8]
    for y in [0...8]
      red   = ~~(Math.random()*4)
      green = ~~(Math.random()*4)
      lp.set x,y,red,green

pulseDemo = ->
  for x in [0...8]
    for y in [0...8]
      dist = Math.sqrt( Math.pow(3.5-x,2) + Math.pow(3.5-y,2) )
      red   = 4-dist / ( Math.sin(time/2) + 1)
      green = dist / ( Math.sin(time/2) + 2)
      lp.set x,y,red,green

cubesDemo = ->
  for x in [0...8]
    for y in [0...8]
      red = 4
      green = 0
      if (x+time) % 4 < 2 then red = 0
      if (y+time) % 4 < 2 then red = 0
      lp.set x,y, red,green

allDemos = ->
  time++
  phase = ~~((time % 60)/20)
  switch phase
    when 0 then noiseDemo()
    when 1 then cubesDemo()
    else pulseDemo()

setInterval allDemos, 100

process.stdin.resume()
