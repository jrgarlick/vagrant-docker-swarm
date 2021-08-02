#!/bin/bash

rm cookies.txt
while true; do
    RESPONSE=`curl -sk -c cookies.txt -b cookies.txt --max-time 3 $1`
    SERVER=`grep 'sticky' cookies.txt | cut -f7 -`
    echo "$SERVER $RESPONSE"
    sleep 0.25;
done;
