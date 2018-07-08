#!/bin/bash -x
set -u

output=${1:-./output}
mkdir -p $output

# get git repositories
## npm-logos
mkdir -p $output/images
git clone --depth 1 https://github.com/npm/logos $output/images/npm-logos
rm -rf $output/images/npm-logos/.git

# process all files
for file in $(find ./content -type f)
do
    echo $(basename $(dirname $file))
    if ! echo $file | grep "src/" > /dev/null
    then
        # ignore src direcotry
        path=$(realpath --relative-to=./content $file)
        mkdir -p $output/$(dirname $path)
        if [ "${file##*.}" = "pug" ]
        then
            #pug file
            $(npm bin)/pug -P $file --out $output/$(dirname $path)
        else
            cp $file $output/$path
        fi
    fi
done