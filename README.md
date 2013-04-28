node-novation-launchpad
===

![Sample](https://raw.github.com/bwiklund/node-novation-launchpad/master/examples/video.gif)

A nodejs wrapper for a Novation Launchpad.

```
npm install novation-launchpad
```

It lets you treat the grid of LEDs as an 8x8 framebuffer, and animate them.

```coffeescript
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

```coffeescript
launchpad = require('launchpad')()

launchpad.onButtonDown = (x,y) ->
  console.log "#{x} x #{y} pressed"

launchpad.onButtonUp = (x,y) ->
  console.log "#{x} x #{y} released"
```

Totally pointless :)
