#!/bin/bash

# Final filename is dependent on the date
dayofweek=`date +%w`
dayofmonth=`date +%d`
month=`date +%m`


if [ $dayofweek = 0 ]; then

  # on Sundays save file as a "weekly" archive
  if [ "$dayofmonth" -ge 1 ] && [ "$dayofmonth" -le 7 ]; then
    filename=week-1

  elif [ "$dayofmonth" -ge 8 ] && [ "$dayofmonth" -le 14 ]; then
    filename=week-2

  elif [ "$dayofmonth" -ge 15 ] && [ "$dayofmonth" -le 21 ]; then
    filename=week-3

  elif [ "$dayofmonth" -ge 22 ] && [ "$dayofmonth" -le 28 ]; then
    filename=week-4

  elif [ "$dayofmonth" -ge 29 ] && [ "$dayofmonth" -le 31 ]; then
    filename=week-5

  fi


else
  # on Monday to Saturday, save as "daily" archive
  filename=day-`date +%w`

fi

if [ "$dayofmonth" = 1 ]; then
  # on the first of the month, ignore all the above and save a monthly file
  filename=month-$month

fi

# By the end, we should have a name like
# week-1 to week-5
# day-1 to day-7
# month-1 to month-12

if [ $backuprotate == 0 ] ; then
        filename=daily
fi
