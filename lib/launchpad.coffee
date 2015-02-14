class Launchpad
  constructor: ->
    @initMidi()
    @clear()

  initMidi: ->
    @midi = require 'midi'
    @midiOut = new @midi.output
    @midiIn = new @midi.input

    process.on 'SIGINT', @onExit

    @midiIn.openPort 0
    @midiIn.on 'message', @onMidiEvent
    @port = -1

    for i in [0...@midiOut.getPortCount()]
      portName = @midiOut.getPortName i
      console.log "Port #{i}: #{portName}"
      if /^Launchpad(:\d+)?/.test portName
        @port = i
        break

    if @port == -1
      throw "Launchpad was not detected"

    @midiOut.openPort(@port)

  onExit: =>
    # in case there's an error, this is ensured to happen
    setTimeout (-> process.exit()), 1000
    @stopMidi()

  onMidiEvent: (delta,msg) =>
    x = msg[1]%16
    y = parseInt (msg[1]/16)
    if msg[2] != 0
      @onButtonDown(x,y)
    else
      @onButtonUp(x,y)

  stopMidi: ->
    console.log "shutting down midi"
    @clear()
    @midiOut.closePort()
    @midiIn.closePort()

  onButtonDown: (x,y) ->

  onButtonUp: (x,y) ->

  # convert XY coordinate to the midi index needed
  xy2i: (x,y) -> 16 * (y%8) + x

  # clamp a number into the int range needed for lighting up pixels
  cRange: (c) -> parseInt Math.min( Math.max( 0,c ), 3 )

  # get a color code
  color: (red,green) -> 0b001100 + @cRange(red) + @cRange(green)*8

  # set a pixel on the board
  set: (x,y,r,g) ->
    @midiOut.sendMessage [144,@xy2i(x,y),@color(r,g)]

  clear: =>
    for x in [0...8]
      for y in [0...8]
        @set x,y,0,0


module.exports = -> new Launchpad


###

for reference:

http://d19ulaff0trnck.cloudfront.net/sites/default/files/novation/downloads/4080/launchpad-programmers-reference.pdf

###
