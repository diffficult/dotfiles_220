#!/usr/bin/env bash
# Launch kitty with float / fullscreen variants for i3

if [ "$1" = "--float" ]; then
	kitty --class kitty-float \
		-o background_opacity=0.80 \
		-o remember_window_size=no \
		-o initial_window_width=100c \
		-o initial_window_height=28c
elif [ "$1" = "--full" ]; then
	kitty --class kitty-full \
		-o remember_window_size=no \
		-o initial_window_width=100c \
		-o initial_window_height=30c \
		-o window_padding_width=30 \
		-o background_opacity=0.92 \
		-o font_size=14
else
	kitty
fi
