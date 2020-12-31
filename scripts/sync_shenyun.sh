#!/bin/bash
# author: gfw-breaker

channels="nf4778 nf4780 nf5951 nf4779 nf1148019 nf1299941"

## create dirs
for channel in $channels ; do
	mkdir -p ../pages/$channel
done
	
## get feeds files
for channel in $channels ; do
	url="http://www.epochtimes.com/gb/$channel.htm"
	echo "getting channel: $url"
	python parse_shenyun.py $channel "$url"
done


