#!/usr/bin/env bash

set -e

rm -rf dist/
mkdir -p dist

echo 'Building for web ...'
godot --no-window --export-release "Web" dist/index.html
echo 'done.'

echo 'Building for linux ...'
godot --no-window --export-release 'Linux/X11' dist/a-mazeing-laughter.x86_64
chmod a+x dist/a-mazeing-laughter.x86_64
echo 'done.'

echo 'Building for Windows ...'
godot --no-window --export-release 'Windows Desktop' dist/a-mazeing-laughter.exe
echo 'done.'
