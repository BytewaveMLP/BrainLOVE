Brainfuck = require 'lib.brainfuck'
Button = require 'lib.button'

brainfuck = nil

love.load = () ->
	export button = Button(
		20,
		20,
		5,
		5,
		(love.graphics.newText (love.graphics.newFont "assets/fonts/hack.ttf"), "Hello!")
	)

	button\setColor 0, 0, 255
	button\setTextColor 255, 255, 255

	button\onClick(((mousedown) =>
		print "Mouse " .. (mousedown and "clicked" or "released")

		if mousedown
			button\setColor 0, 255, 0
		else
			button\setColor 255, 0, 0
	))

	button\onHover(((entered) =>
		print "Mouse " .. (entered and "entered" or "exitted")

		if entered
			button\setColor 255, 255, 0
		else
			button\setColor 0, 0, 255
	))

love.update = (dt) ->
	mouseX = love.mouse.getX!
	mouseY = love.mouse.getY!

	button\handleHover mouseX, mouseY

love.mousepressed = (x, y, mbtn, touch) ->
	button\handleClick x, y, mbtn, touch, true

love.mousereleased = (x, y, mbtn) ->
	button\handleClick x, y, mbtn, nil, false

love.draw = () ->
	button\draw!
