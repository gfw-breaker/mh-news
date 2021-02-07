#!/bin/bash
# author: gfw-breaker

channels="282 251 245 140 91 328 277 81 78 365 73 87"

## create dirs
for channel in $channels ; do
	mkdir -p ../pages/$channel
done
	
## get feeds files
for channel in $channels ; do
	file=cat$channel.js
	#if [[ $channel == "91" ]] || [[ $channel == "81" ]] || [[ $channel == "78" ]] || [ $channel == '73' ]; then
	if [[ ",91,81,78,73," == *,$channel,* ]]; then
		file=cat$channel-2021.js
	fi 
	url="http://www.minghui.org/mh/fenlei/$channel/$file" 
	wget -q $url -O $channel.js
	sed -i '1s/^.*$/[/' $channel.js	
	sed -i 's/]];/]]/' $channel.js	
	sed -i '/369961/d' $channel.js	
	sed -i '/14899.html/d' $channel.js	
	echo "getting channel: $url"
	python parse_mh.py $channel
done


