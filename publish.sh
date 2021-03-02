#!/bin/sh
# build root
npx honkit build
mv ./_book/* .

# build books
# for test
cd coroutine-migration-guide || exit
npx honkit build
mv ./_book/* .
../customize_html.py "$(pwd)/index.html"
cd ..

# after
chmod +x ./publish.sh
chmod +x ./customize_html.py
