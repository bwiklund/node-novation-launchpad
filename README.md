node-novation-launchpad
===

A midi wrapper for a Novation Launchpad. 

It lets you treat the grid of LEDs as an 8x8 framebuffer, and animate them.

```
lp = require('../lib/launchpad')()

noiseDemo = ->
  for x in [0...8]
    for y in [0...8]
      red   = ~~(Math.random()*4)
      green = ~~(Math.random()*4)
      lp.set x,y,red,green

setInterval noiseDemo, 100
```

You can also capture button up/down input from the pad.

Totally pointless :)
