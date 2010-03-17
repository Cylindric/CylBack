#!/bin/bash

op_message=""
op_status="ok"
op_started=0

# If we're not running in an interactive terminal, use simple output
if [[ -n "${TERM:+x}" || ${TERM} == "dumb" ]]; then
	op_term=0
else
	op_term=1
fi


function StartMessage() {
	op_message=$1

	if [ $op_started -eq 1 ]
	then
	  EndMessage ""
	fi

	if [ $op_term -eq 0 ]; then
		printf "${op_message}"
	else
		op_colour="1;37"
		printf "\033[${op_colour}m${op_message}\033[00m"
	fi
	op_status="ok"
	op_started=1
}

function EndMessage() {
	op_colour="0;32"

	for arg in "$@"
	do
	  op_status=$arg
	done

	if [ "$op_status" == "" ]
	then
		printf "\n"
	else

		# 31 = red
	  # 32 = green
	  # 33 = yellow
	  # 34 = blue
	  if [ "$op_status" == "ok" ]
	  then
	    op_colour="0;32"
		elif [ "$op_status" == "skipped" ]
		then
	    op_colour="0;34"
		elif [ "$op_status" == "warning" ]
		then
	    op_colour="0;33"
	 	else
	 	  op_colour="0;31"
		fi

		if [ $op_term -eq 0 ]; then
  	  printf " ${op_status}\n"
		else
	    printf "%$(($(tput cols) - ${#op_message} - ${#op_status} - 2))s%b\n" " " "[\033[${op_colour}m${op_status}\033[00m]"
		fi
	fi
	op_started=0
}
