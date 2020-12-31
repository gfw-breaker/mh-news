#!/bin/bash

org=$1
new=$2

mds=$(ls ../pages/*/*.md)

for md in $mds; do
	echo $md
	sed -i "s#$org#$new#g" $md
done


sed -i "s#$org#$new#g" ../pages/link4.md
sed -i "s#$org#$new#g" macros.py


