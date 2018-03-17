Brainfuck = require 'lib.brainfuck'
Button = require 'lib.button'

love.load = () ->
	export brainfuck = Brainfuck('++++++++++[>+++++++>++++++++++>+++>+<<<<-]>++.>+.+++++++..+++.>++.<<+++++++++++++++.>.+++.------.--------.>+.>.')

	export running = false

	export hackFont = love.graphics.newFont "assets/fonts/hack.ttf", 24

	export outStr = ""
	export outText = love.graphics.newText hackFont, outStr

	export runButton = Button(
		20,
		20,
		5,
		5,
		(love.graphics.newText hackFont, "RUN")
	)

	runButton\setColor 255, 150, 150
	runButton\setTextColor 255, 255, 255

	runButton\onClick(((mousedown) =>
		if mousedown
			if running
				runButton\setColor 175, 100, 100
			else
				runButton\setColor 100, 175, 100
		else
			if running
				runButton\setColor 150, 255, 150
				resetButton\setColor 125, 125, 125
			else
				runButton\setColor 255, 150, 150
				resetButton\setColor 255, 150, 150

			running = not running
	))

	runButton\onHover(((entered) =>
		if entered
			if running
				runButton\setColor 125, 200, 125
			else
				runButton\setColor 200, 125, 125
		else
			if running
				runButton\setColor 150, 255, 150
			else
				runButton\setColor 255, 150, 150
	))

	export resetButton = Button(
		20,
		70,
		5,
		5,
		(love.graphics.newText hackFont, "RESET")
	)

	resetButton\setColor 125, 125, 125
	resetButton\setTextColor 255, 255, 255

	resetButton\onClick(((mousedown) =>
		if mousedown then return
		if not running then return

		brainfuck\reset!
		running = false
		outStr = ""
		outText\set outStr
		runButton\setColor 255, 150, 150
		resetButton\setColor 125, 125, 125
	))

love.update = (dt) ->
	mouseX = love.mouse.getX!
	mouseY = love.mouse.getY!

	runButton\handleHover mouseX, mouseY
	resetButton\handleHover mouseX, mouseY

	if running
		out = brainfuck\step!
		if out
			export outStr = outStr .. out
			outText\set outStr

love.mousepressed = (x, y, mbtn, touch) ->
	runButton\handleClick x, y, mbtn, touch, true
	resetButton\handleClick x, y, mbtn, touch, true

love.mousereleased = (x, y, mbtn) ->
	runButton\handleClick x, y, mbtn, nil, false
	resetButton\handleClick x, y, mbtn, nil, false

love.draw = () ->
	runButton\draw!
	resetButton\draw!
	love.graphics.draw outText, 20, 150
