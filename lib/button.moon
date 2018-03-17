export Button

class Button
	new: (@x, @y, @padding, @roundedPx, @text) =>
		@width = 2 * @padding + @text\getWidth!
		@maxX = @width + @x
		@height = 2 * @padding + @text\getHeight!
		@maxY = @height + @y

		@color =
			r: 0
			g: 0
			b: 0

		@textColor =
			r: 255
			g: 255
			b: 255

		@clicked = false
		@hovered = false

	--- Tests to see if the given coordinate is within the bounds of the button
	-- @param x The x component of the coordinate
	-- @param y The y component of the coordinate
	-- @return true if the coordinate falls within the button's bounds, false if not
	insideBounds: (x, y) =>
		(x >= @x and x <= @maxX) and (y >= @y and y <= @maxY)

	--- Handles a mouse button event
	-- @param x The x component of the event
	-- @param y The y component of the event
	-- @param button The mouse button in question
	-- @param mousedown Whether the button was pressed or released
	handleClick: (x, y, button, _, mousedown) =>
		if not @onclick then return

		if mousedown
			if @insideBounds x, y
				@onclick true
				@clicked = true
		elseif @clicked
			@onclick false
			@clicked = false

	--- Handles a hover event
	-- @param x The x component of the event
	-- @param y The y component of the event
	handleHover: (x, y) =>
		if not @onhover then return
		if @clicked then return

		if (@insideBounds x, y)
			if not @hovered
				@hovered = true
				@onhover true
		else
			if @hovered
				@hovered = false
				@onhover false

	--- Sets the handler function for a click event
	-- @param fn The function to use as a handler (should accept a "mousedown" parameter, as this is run both when the mouse is pressed and released)
	onClick: (fn) =>
		@onclick = fn

	--- Sets the handler function for a hover event
	-- @param fn The function to use as a handler (should accept an "entered" parameter, as this is run both when the mouse emters amd exits the bounds
	onHover: (fn) =>
		@onhover = fn

	--- Sets the background color of the button
	-- @param r The red component of the color (0-255)
	-- @param g The green component of the color (0-255)
	-- @param b The blue component of the color (0-255)
	setColor: (r, g, b) =>
		@color = { :r, :g, :b }

	--- Sets the foreground (text) color of the button
	-- @param r The red component of the color (0-255)
	-- @param g The green component of the color (0-255)
	-- @param b The blue component of the color (0-255)
	setTextColor: (r, g, b) =>
		@textColor = { :r, :g, :b }

	--- Sets the text object to be used as the button text
	-- This will automatically recalculate the button's size based on text metrics
	-- @param text A LOVE2D Text object to set the button's text to
	setText: (text) =>
		@text = text

		-- recalculate sizing based on text metrics
		@width = 2 * @padding + @text\getWidth!
		@maxX = @width + @x
		@height = 2 * @padding + @text\getHeight!
		@maxY = @height + @y

	--- Draws the button
	-- Call this on every frame (in love.draw)
	draw: () =>
		love.graphics.setColor @color.r, @color.g, @color.b
		love.graphics.rectangle "fill", @x, @y, @width, @height, @roundedPx
		love.graphics.setColor @textColor.r, @textColor.g, @textColor.b
		love.graphics.draw @text, (@x + @padding), (@y + @padding)
