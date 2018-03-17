export Brainfuck

class Brainfuck
	new: (@code) =>
		@tape = {}
		@loopStarts = {}
		@currentCell = 1
		@pointer = 1

		for i = 1, 256
			@tape[i] = 0

	getTape: => @tape

	validate: =>
		_, openCount  = @code\gsub "%[", ""
		_, closeCount = @code\gsub "%]", ""

		openCount == closeCount

	atEnd: => @pointer == @code\len! + 1

	step: =>
		if @atEnd! then return

		instruction = @code\sub @pointer, @pointer

		switch instruction
			when "+"
				@tape[@currentCell] = @tape[@currentCell] + 1
				if @tape[@currentCell] > 255 then @tape[@currentCell] = 0
			when "-"
				@tape[@currentCell] = @tape[@currentCell] - 1
				if @tape[@currentCell] < 0 then @tape[@currentCell] = 255
			when ">"
				@currentCell = @currentCell + 1
				if @currentCell > 256 then @currentCell = 1
			when "<"
				@currentCell = @currentCell - 1
				if @currentCell < 1 then @currentCell = 256
			when "["
				table.insert @loopStarts, @pointer
			when "]"
				loopStart = table.remove @loopStarts

				if @tape[@currentCell] ~= 0
					@pointer = loopStart - 1
			when "."
				io.write (string.char @tape[@currentCell])

		@pointer = @pointer + 1

	runToEnd: =>
		while not @atEnd!
			@step!

	reset: =>
		for i = 1, 256
			@tape[i] = 0
		@pointer = 1
		@currentCell = 1
		@loopStarts = {}

	printLoops: =>
		loopsStr = "LOOP: "

		for i = 1, #@loopStarts
			loopsStr = loopsStr .. @loopStarts[i] .. (i ~= #@loopStarts and ', ' or '')

		print loopsStr

	printTape: =>
		tapeStr = "TAPE: "

		for i = 1, #@tape
			tapeStr = tapeStr .. @tape[i] .. (i ~= #@tape and ', ' or '')

		print tapeStr

	__tostring: =>
		ret = "CODE: #{@code}\n"
		ret = ret .. "     "

		for i = 1, @pointer
			ret = ret .. " "
		ret = ret .. "^"

		ret
