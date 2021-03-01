#!/bin/sh
# build root
npx honkit build
mv ./_book/* .

# build books
# for test
cd coroutine-migration-guide || exit
npx honkit build
mv ./_book/* .
cd ..

# after
chmod +x ./publish.sh
