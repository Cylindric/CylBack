#!/bin/bash

op_message=""
op_status="ok"
op_started=0
op_tmpmessage=""
op_filename=""

# If we're not running in an interactive terminal, use simple output
tty -s
if [ $? -gt 0 ]; then
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
		op_tmpmessage="${op_message}"
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
		if [ $op_term -eq 0 ]; then
  	  echo "${op_tmpmessage}" >> $op_filename
		else
			printf "\n"
		fi

	else

		op_tmpmessage="${op_tmpmessage} ${op_status}"

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
  	  echo "${op_tmpmessage}" >> $op_filename
		else
	    printf "%$(($(tput cols) - ${#op_message} - ${#op_status} - 2))s%b\n" " " "[\033[${op_colour}m${op_status}\033[00m]"
		fi
		
		# track the final status in case there was a reported failure
		if [ "$op_finalstatus" = "ok" ]
		then
			if [[ "$op_status" != "ok" && "$op_status" != "" ]]
			then
				op_finalstatus="error"
			fi
		fi
				
	fi
	op_started=0
}
