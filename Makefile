LOVE = love
MOONC = moonc

.PHONY: clean build run

run: clean build
	${LOVE} build

clean:
	rm -rfv build

build:
	${MOONC} -t build .
