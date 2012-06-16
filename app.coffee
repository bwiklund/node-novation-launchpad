#rad

#utils
array = (w,h,v) ->
	[0...w].map -> [0...h].map -> v

class Diode
	constructor: ->
		@midi = require 'midi'
		@mout = new @midi.output
		@min = new @midi.input

		process.on 'exit', =>
			@mout.closePort()
			@min.closePort()

		@min.openPort 0

		[0...@mout.getPortCount()].map (i)=>
			console.log @mout.getPortName(i)
		console.log @mout.openPort(0);

		@currentMode = new Memory this

		@min.on 'message', (delta,msg) => 
			x = msg[1]%16
			y = parseInt (msg[1]/16)
			@currentMode.press x,y
			

		



		t = 0
		pulse = =>
			t++
			for i in [0...64]
				x = (i%8)
				y = parseInt (i/8)
				color = @color parseInt(Math.random()*4), parseInt(Math.random()*4)
				d = Math.sqrt( Math.pow(3.5-x,2) + Math.pow(3.5-y,2) )
				red = 4-d / ( Math.sin(t/2) + 1)
				green = 0#d / ( Math.sin(t/2) + 2)
				color = @color red,green

				pos = @xy2i x,y
				@mout.sendMessage [144,pos,color]


		random = =>
			for i in [0...64]
				x = (i%8)
				y = parseInt (i/8)
				color = @color parseInt(Math.random()*4), parseInt(Math.random()*4)
				pos = @xy2i x,y
				@mout.sendMessage [144,pos,color]


		clear = =>
			for i in [0...64]
				x = (i%8)
				y = parseInt (i/8)
				@set x,y,0,0


		clear()
		#setInterval random, 1


	xy2i: (x,y) -> 16 * (y%8) + x
	cRange: (c) -> parseInt Math.min( Math.max( 0,c ), 3 )
	color: (red,green) -> 0b001100 + @cRange(red) + @cRange(green)*8

	set: (x,y,r,g) ->
		@mout.sendMessage [144,@xy2i(x,y),@color(r,g)]



class Mode 
	constructor: (@diode) ->
	set: (args...) -> @diode.set args...

class Basic extends Mode
	press: (x,y) ->
		@set x,y,3,3
		setTimeout (=> @set x,y,0,3), 300
		setTimeout (=> @set x,y,0,0), 600

class Memory extends Mode
	constructor: ->
		@d = array 8,8,0

	press: (x,y) ->
		@set x,y,3,3
		setTimeout (=> @set x,y,0,3), 300
		setTimeout (=> @set x,y,0,0), 600




new Diode

process.stdin.resume()


###
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
