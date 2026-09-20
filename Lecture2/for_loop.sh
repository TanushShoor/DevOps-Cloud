#!/bin/bash
# for i in {1..5}
# do
#     echo"THis is iteration number $i"
# done


sum=0
for i in {1..5}
do
    ((sum+=(i)))
done
echo $sum