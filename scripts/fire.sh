#!/bin/bash
# author: gfw-breaker

folder=$(dirname $0)
echo $folder
cd $folder

## pull
mkdir -p ../indexes
mkdir -p ../pages
rm *xml*
git pull

## sync
for sf in $(ls sync_*.sh); do
	bash $sf
done

## remove video news
tt=$(date "+%m%d%H%M")
for f in $(ls ../indexes/*); do
	sed -i "s/\.md)/\.md?t=$tt)/g" $f
	sed -i "/视频）/d" $f
	sed -i "/视频)/d" $f
done


## add qr code
base_url="https://github.com/gfw-breaker/mh-news/blob/master"
for d in $(ls ../pages/); do
    for f in $(ls -t ../pages/$d | grep 'md$'); do
		a_path="../pages/$d/$f"
		a_url="$base_url/pages/$d/$f"
		if [ ! -f $a_path.png ]; then
			qrencode -o $a_path.png -s 4 $a_url
		fi
    done
done


## geneate indexes
while read line; do
	key=$(echo $line | cut -d',' -f1)
	name=$(echo $line | cut -d',' -f2)
	cname=$(echo $name | cut -c2-)
	cat links1.txt > tmp.md
	head -n 3 ../indexes/$key.md >> tmp.md
	cat links2.txt >> tmp.md
	sed -n '4,6p' ../indexes/$key.md >> tmp.md	
	cat links3.txt >> tmp.md
	sed -n '7,9p' ../indexes/$key.md >> tmp.md	
	cat links4.txt >> tmp.md
	sed -n '10,$p' ../indexes/$key.md >> tmp.md	
	mv tmp.md ../indexes/$name.md
	echo -e "\n### 已转移至新页面 [$cname]($name.md) \n" > ../indexes/$key.md
done < ../indexes/names.csv


## add to git
git add ../indexes/*
git add ../pages/*


## purge old entries
for d in $(ls ../pages/); do
    for f in $(ls -t ../pages/$d | grep 'md$' | sed -n '300,$p'); do
        git rm "../pages/$d/$f"   
        git rm "../pages/$d/$f.png"   
    done
done


## write README.md
rm *.xml
sed -i "s/\.md?t=[0-9]*)/.md?t=$tt)/g" ../README.md
git add ../README.md

ts=$(date "+-%m月-%d日-%H时-%M分" | sed 's/-0//g' | sed 's/-//g')
git commit -a -m "同步于: $ts"
git push

