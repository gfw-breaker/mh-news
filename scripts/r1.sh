#!/bin/bash

mds=$(ls ../pages/*/*.md)

for md in $mds; do
	echo $md
	sed -i 's#/banned-news/#/banned-news1/#g' $md
done

