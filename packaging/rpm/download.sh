#!/bin/sh

VERSION=$1
while read url file; do
    eval "url=$url"
    eval "file=$file"
    wget -nc -O $HOME/rpmbuild/SOURCES/$file $url
done < qt.sources
