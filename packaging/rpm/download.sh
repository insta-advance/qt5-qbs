#!/bin/sh

if [ -z "$1" ]; then echo "Usage: $0 <tag-to-download>"; exit 1; fi

VERSION=$1
while read url file; do
    eval "url=$url"
    eval "file=$file"
    wget -nc -O $HOME/rpmbuild/SOURCES/$file $url
done < qt.sources
