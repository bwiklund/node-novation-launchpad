#!/usr/bin/env coffee

class Launchpad
  constructor: ->
    @initMidi()
    @clear()
    setInterval @pulse, 1


  initMidi: ->
    @midi = require 'midi'
    @midiOut = new @midi.output
    @midiIn = new @midi.input

    process.on 'SIGINT', => 
      setTimeout (-> process.exit()), 1000 # in case there's an error, this is ensured to happen
      @stopMidi()
      #process.exit()


    @midiIn.openPort 0
    @midiIn.on 'message', (delta,msg) => 
      x = msg[1]%16
      y = parseInt (msg[1]/16)
      if msg[2] != 0
        @onButtonDown(x,y)
      else 
        @onButtonUp(x,y)

    for i in [0...@midiOut.getPortCount()]
      console.log "Port #{i}: " + @midiOut.getPortName(i)

    #TODO: handle multiple midi ports and choose the right one
    @midiOut.openPort(0)


  stopMidi: ->
    console.log "shutting down midi"
    @clear()
    @midiOut.closePort()
    @midiIn.closePort()


  onButtonDown: (x,y) ->
    console.log "#{x} x #{y} pressed"
  
  onButtonUp: (x,y) ->
    console.log "#{x} x #{y} released"

  # convert XY coordinate to the midi index needed
  xy2i: (x,y) -> 16 * (y%8) + x

  # clamp a number into the int range needed for lighting up pixels
  cRange: (c) -> parseInt Math.min( Math.max( 0,c ), 3 )

  # get a color code
  color: (red,green) -> 0b001100 + @cRange(red) + @cRange(green)*8

  # set a pixel on the board
  set: (x,y,r,g) ->
    @midiOut.sendMessage [144,@xy2i(x,y),@color(r,g)]

  ### some animation tests ###

  # animated glowing thing
  pulse: =>
    @t ?= 0
    @t++
    for x in [0...8]
      for y in [0...8]
        color = @color parseInt(Math.random()*4), parseInt(Math.random()*4)
        dist = Math.sqrt( Math.pow(3.5-x,2) + Math.pow(3.5-y,2) )
        red = 4-dist / ( Math.sin(@t/2) + 1)
        green = dist / ( Math.sin(@t/2) + 2)
        color = @color red,green

        pos = @xy2i x,y
        @midiOut.sendMessage [144,pos,color]


  # random noise pattern
  random: =>
    for x in [0...8]
      for y in [0...8]
        color = @color parseInt(Math.random()*4), parseInt(Math.random()*4)
        pos = @xy2i x,y
        @midiOut.sendMessage [144,pos,color]


  # clear the screen
  clear: =>
    for x in [0...8]
      for y in [0...8]
        @set x,y,0,0





new Launchpad

process.stdin.resume()


###

some stuff from the novation dev guide pdf


Set grid LEDs
Hex version 90h, Key, Velocity. 
Decimal version 144, Key, Velocity.
A note-on message changes the state of a grid LED. Key is the MIDI note number, which determines the LED location. Velocity is used to set the LED colour. Launchpad can be configured to map its buttons to MIDI note messages in one of two ways. The differences between these mapping modes are covered later, and can be seen in Figures 1 and 2. The default mapping is the X-Y layout. In this mapping, locations are addressed as follows, with the origin being the square button at the top-left corner of the grid:
Hex version Key = (10h x Row) + Column 
Decimal version Key = ( 16 x Row) + Column


Bit Name
6
5..4 Green 3 Clear 2 Copy
1..0 Red
Meaning
Must be 0.
Green LED brightness.
If 1: clear the other buffer’s copy of this LED. If 1: write this LED data to both buffers.
Note: this behaviour overrides the Clear behaviour when both bits are set.
Red LED brightness.

###
