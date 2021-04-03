#! /bin/sh

set -u

output=${1:-./output}
mkdir -p $output

# build jekyll
bundle exec jekyll build -d $output
