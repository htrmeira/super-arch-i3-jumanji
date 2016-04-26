#!/bin/bash

INET=wlan0
INTERVAL=5.0
TMP_RESULTS=/tmp/.netstatus

load_current() {
	current_results=$(cat /proc/net/dev | grep -i $INET);
	current_received=$(echo $current_results | awk '{ print $2 }');
	current_transmitted=$(echo $current_results | awk '{ print $10 }');
}

load_prev() {
	if [ -f $TMP_RESULTS ]; then
		prev_results=$(cat $TMP_RESULTS | grep -i $INET);
		prev_received=$(echo $prev_results | awk '{ print $2 }');
		prev_transmitted=$(echo $prev_results | awk '{ print $10 }');
	else
		prev_received=$current_received;
		prev_transmitted=$current_transmitted;
	fi;
}

load_stats() {
	load_current;
	load_prev;
}

format_value() {
	per_interval=$(echo "($1 / $INTERVAL)" | bc)
	if [ $per_interval -gt 1048576 ]; then
		echo "$(echo "scale=2; ($per_interval / 1048576)" | bc -l) MBps"
	# kilo
	elif [ $per_interval -gt 1024 ]; then
		echo "$(echo "scale=2; ($per_interval / 1024)" | bc -l) KBps"
	# Bytes
	else
		echo "$per_interval Bps";
	fi
}

create_prev_file() {
	echo $current_results > $TMP_RESULTS;
}

show() {
	load_stats;

	received=$(echo "($current_received - $prev_received)" | bc)
	transmitted=$(echo "($current_transmitted - $prev_transmitted)" | bc)

	create_prev_file;

	echo "$(format_value $transmitted)/$(format_value $received)"
}

show;
