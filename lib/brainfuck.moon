export Brainfuck

class Brainfuck
	new: (@code, @stdin) =>
		@tape = {}
		@loopStarts = {}
		@currentCell = 1
		@pointer = 1
		if not @stdin then @stdin = ""
		@stdinPointer = 1

		for i = 1, 256
			@tape[i] = 0

	--- Gets the current state of the tape
	-- @returns A table of length 256 representing the cells on the tape
	getTape: => @tape

	--- Validates the Brainfuck object to ensure the code is in a working state
	-- Ensures that there are an equal number of [s and ]s.
	-- @returns Whether or not the number of [s equals the number of ]s.
	validate: =>
		_, openCount  = @code\gsub "%[", ""
		_, closeCount = @code\gsub "%]", ""

		openCount == closeCount

	--- Determines whether the code is finished executing
	-- @returns Whether or not the pointer is off the edge of the code
	atEnd: => @pointer == @code\len! + 1

	--- Runs a single Brainfuck instruction
	-- @returns The output of the instructino, if any
	step: =>
		if @atEnd! then return

		instruction = @code\sub @pointer, @pointer

		out = nil

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
				out = string.char @tape[@currentCell]
			when ","
				if @stdinPointer > @stdin\len!
					@tape[@currentCell] = 0
				else
					@tape[@currentCell] = string.byte (@stdin\sub @stdinPointer, @stdinPointer)
					@stdinPointer = @stdinPointer + 1

		@pointer = @pointer + 1

		out

	--- Runs steps of Brainfuck code until it's complete, printing all output
	runToEnd: =>
		while not @atEnd!
			out = @step!

			if out
				io.write out

	--- Resets the internal state of Brainfuck execution to the beginning
	reset: (stdin) =>
		for i = 1, 256
			@tape[i] = 0
		@pointer = 1
		@currentCell = 1
		@loopStarts = {}
		@stdin = stdin or ""
		@stdinPointer = 1

	--- DEBUGGING CODE: Prints the current loop pointers
	printLoops: =>
		loopsStr = "LOOP: "

		for i = 1, #@loopStarts
			loopsStr = loopsStr .. @loopStarts[i] .. (i ~= #@loopStarts and ', ' or '')

		print loopsStr

	--- DEBUGGING CODE: Prints the current tape state
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
