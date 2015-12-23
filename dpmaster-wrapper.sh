#!/bin/bash

# This script makes sure dpmaster exits quickly by reliably proxying
# the SIGTERM coming from Docker on container shutdown.

# trap the sigterm signal
_term() {
	# send termination request and wait for process to exit
	kill "$child"
	wait "$child"

	# error code 143 means exit caused by bash's kill request
	retval=$?
	[ "$retval" -eq 143 ] && retval=0

	# any other error code should be forwarded as is
	exit $retval
}
trap _term SIGTERM

# start dpmaster
dpmaster &
child=$!
wait "$child"
