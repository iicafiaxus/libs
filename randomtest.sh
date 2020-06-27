#!/bin/sh

if [ ! -e "$1" ]; then
	echo "$1 が存在しません."
	exit
fi

i=0
while true; do
	i=`expr $i + 1`
	$1 -gen > $1_rand.txt
	yourans=$($1 < $1_rand.txt)
	juryans=$($1 -jury < $1_rand.txt)
	if [ "$yourans" != "$juryans" ]; then
		echo "Test #$i: Wrong answer"
		echo "Input:"
		cat $1_rand.txt
		echo "Your answer:"
		echo $yourans
		echo "Jury's answer:"
		echo $juryans
		exit
	else
		echo "Test #$i: Ok"
	fi
done
