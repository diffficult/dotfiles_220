#!/usr/bin/env bash
# Toggle a dedicated scratchpad terminal (kitty-scratch)

if i3-msg -t get_tree | grep -q '"class":"kitty-scratch"'; then
	i3-msg '[class="kitty-scratch"] scratchpad show, move position center'
else
	kitty --class kitty-scratch \
		-o background_opacity=0.78 \
		-o remember_window_size=no \
		-o initial_window_width=110c \
		-o initial_window_height=32c &
fi
