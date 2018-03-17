LOVE = love
MOONC = moonc

.PHONY: clean build run package bin

package: clean build
	mkdir -pv out
	cd build; zip -9 -r ../out/BrainLOVE.love .

linux: package
	cat $(shell which love) out/BrainLOVE.love > out/BrainLOVE
	chmod +x out/BrainLOVE

build:
	${MOONC} -t build .

clean:
	rm -rfv build
	rm -rfv out

run: clean build
	${LOVE} build
