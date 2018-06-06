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

	runButton\setColor 1, 0.588, 0.588
	runButton\setTextColor 1, 1, 1

	runButton\onClick(((mousedown) =>
		if mousedown
			if running
				runButton\setColor 0.686, 0.392, 0.392
			else
				runButton\setColor 0.392, 0.686, 0.392
		else
			if running
				runButton\setColor 0.588, 1, 0.588
				resetButton\setColor 0.490, 0.490, 0.490
			else
				runButton\setColor 1, 0.588, 0.588
				resetButton\setColor 1, 0.588, 0.588

			running = not running
	))

	runButton\onHover(((entered) =>
		if entered
			if running
				runButton\setColor 0.490, 0.784, 0.490
			else
				runButton\setColor 0.784, 0.490, 0.490
		else
			if running
				runButton\setColor 0.588, 1, 0.588
			else
				runButton\setColor 1, 0.588, 0.588
	))

	export resetButton = Button(
		20,
		70,
		5,
		5,
		(love.graphics.newText hackFont, "RESET")
	)

	resetButton\setColor 0.490, 0.490, 0.490
	resetButton\setTextColor 1, 1, 1

	resetButton\onClick(((mousedown) =>
		if mousedown then return
		if not running then return

		brainfuck\reset!
		running = false
		outStr = ""
		outText\set outStr
		runButton\setColor 1, 0.588, 0.588
		resetButton\setColor 0.490, 0.490, 0.490
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
