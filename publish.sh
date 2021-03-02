#!/bin/sh
# build root
cd src || exit
npx honkit build
mv ./_book/* ..

# build books
# TODO python으로 디렉토리별로 만들도록 하기
cd coroutine-migration-guide || exit
npx honkit build
mkdir -p ../../coroutine-migration-guide
mv ./_book/* ../../coroutine-migration-guide
cd ../../coroutine-migration-guide || exit
../customize_html.py "$(pwd)/index.html"
cd ../src || exit

# after
cd ..
chmod +x ./publish.sh
chmod +x ./customize_html.py
