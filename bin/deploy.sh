#!/bin/sh -x
set -u

tmpdir=$(mktemp -d)

$(dirname $0)/generate.sh $tmpdir
git -C $tmpdir init
push_url=$(git remote show -n origin | grep "Push" | sed -e 's/^ *Push  *URL: //g')
git -C $tmpdir remote add origin $push_url
git -C $tmpdir checkout -b master
git -C $tmpdir add $tmpdir/*
git -C $tmpdir commit -m "$(LANG=C date)"
git -C $tmpdir push -f origin master

rm -rf $tmpdir
