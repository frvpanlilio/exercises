#Francis Regor V. Panlilio

#!/bin/bash
clear

MEMORY_USAGE=$(free -m | grep Mem: | awk '{printf("%.0f"),$3/$2 * 100.0}')
echo "TOTAL MEMORY USAGE $MEMORY_USAGE%";

TOP_PROCESESS=$( ps aux --sort -rss | head -n 11 )
echo "$TOP_PROCESESS"

EMAIL_SUBJECT=`date +%Y%m%d" "%H:%M`
echo "$EMAIL_SUBJECT"

if [ $# -eq 0 ]; then
echo "Please Input Valid Parameters"
exit 0
fi

while getopts ":c:w:e:" opt; do
   case $opt in
        c)
          critical=$OPTARG;;
        w)
          warning=$OPTARG;;
        e)
          email=$OPTARG;;
        :)
          echo "Invalid Parameters, please supply Ex. memory_check -w 60 -c 90 -e email@me.com"
          exit 0
          ;;
    esac
done

if [ $warning -lt $critical ]; then

        if [ $MEMORY_USAGE -lt $warning ]; then
                echo "The current memory is in normal"
                exit 0
        elif [[ $MEMORY_USAGE -ge $warning && $MEMORY_USAGE -lt $critical ]]; then
                echo "The current memory is in warning"
                echo "The current memory is in warning" | mail -s "$EMAIL_SUBJECT memory check-warning" $email
                exit 1
        elif [ $MEMORY_USAGE -ge $critical ]; then
                echo "The current memory is in critical"
                echo -e "The current memory is in critical \n \n $TOP_PROCESESS" | mail -s "$EMAIL_SUBJECT memory check-critical" $email
                exit 2
        fi
else
        echo "The warning should be lower and not equal to critical input ";
        exit 0
fi
