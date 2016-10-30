#!/bin/bash

XRANDR=/usr/bin/xrandr

# display status for all video ports in this machine.
# We are excluding the original and primary monitor (LVDS1)
# And VIRTUAL1 to avoid mistakes
list_connected_mointors() {
	$XRANDR | grep -v ^' \|^VIRTUAL1\|^LVDS-1' | grep -iw 'connected' | awk '{ print $1 }'
}

# Counts that number of connected monitors
num_extra_monitors() {
	list_connected_mointors | wc -w
}

# This method basically alternates between on and two monitors.
# The secondary monitor will be configured left of the primary,
# the primary monitor is LVDS1.
get_connected_monitors_names() {
	local n_extra_monitors=$(num_extra_monitors)

	if [ $n_extra_monitors == 0 ]; then
		echo "Configuring to primary monitor only..."
		$XRANDR --auto
	elif [ $n_extra_monitors == 1 ]; then
		echo "Secondary found..."
		local monitor=$(list_connected_mointors);

		echo "Configuring $monitor..."
		$XRANDR --output $monitor --auto --right-of LVDS-1
	else
		echo "Unknown number of monitors"
		echo "This might mean more than 2 monitors or an internal error"
		exit 15;
	fi

}

get_connected_monitors_names;
