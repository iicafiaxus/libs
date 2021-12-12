#!/bin/sh

if [ ! -e "$1" ]; then
	echo "$1 が存在しません."
	exit
fi

i=0
while true; do
	i=`expr $i + 1`
	$1 -gen > $1_rand_in.txt
	$1 < $1_rand_in.txt > $1_rand_out.txt
	yourans=$(cat $1_rand_out.txt)
	cat $1_rand_in.txt > $1_rand_inout.txt
	cat $1_rand_out.txt >> $1_rand_inout.txt
	juryans=$($1 -jury < $1_rand_inout.txt)
	if [ "$yourans" != "$juryans" ]; then
		echo "Test #$i: Wrong answer"
		echo "Input:"
		cat $1_rand_in.txt
		echo "Your answer:"
		echo $yourans
		echo "Jury's answer:"
		echo $juryans
		exit
	else
		echo "Test #$i: Ok"
	fi
done
