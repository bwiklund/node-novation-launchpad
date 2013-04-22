node-novation-launchpad
===

A nodejs wrapper for a Novation Launchpad.

npm install:
```npm install git://github.com/bwiklund/node-novation-launchpad.git```

It lets you treat the grid of LEDs as an 8x8 framebuffer, and animate them.

```
launchpad = require('launchpad')()

noiseDemo = ->
  for x in [0...8]
    for y in [0...8]
      red   = ~~(Math.random()*4)
      green = ~~(Math.random()*4)
      launchpad.set x,y,red,green

setInterval noiseDemo, 100
```

You can also capture button up/down input from the pad.

Totally pointless :)
