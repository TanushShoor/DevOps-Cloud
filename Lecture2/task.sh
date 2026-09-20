#print the current date
# current_date = $(date)
# echo "$current_date"
date
#hostname and username
hostname
who
#process
ps

#add process info inside a file name process.log
ps > process.log
#print name, roll_no, comment
name="Tanush Shoor"
echo $name

roll_no="24BCS10265"
echo $roll_no

comment="Hi there"
echo $comment
# use variables, take input, create file and directory

echo "tell me about your self."
read -p "what is your name : " name

read -p "What would the directory you would want to be: " directoryName
mkdir $directoryName
read -p "What would be the filename you want: " fileName
cd $directoryName
touch $fileName
cd ..
mv process.log $directoryName
