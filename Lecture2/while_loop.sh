#!/bin/bash

count=0
while [ $count -lt 5 ]
do
    echo "The iteration number $count"
    ((count++))
done