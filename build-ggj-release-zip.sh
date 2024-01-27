#!/bin/bash

#./build.sh

rm -f a-mazeing-laughter-ggj2024.zip

mkdir -p ggj-release/src
cp -r -- * ggj-release/src/
rm -rf ggj-release/src/ggj-release

(
	cd ggj-release/ || exit

	mv src/dist/ release

	mkdir press
	cp src/assets/screenshots/*.png press/

	zip -r ../a-mazeing-laughter-ggj2024.zip .
)

rm -r ggj-release/
