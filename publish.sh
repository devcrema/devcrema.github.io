#!/bin/sh
# build root
npx honkit build
mv ./_book/* .

# build books
# for test
cd test-honkit
npx honkit build
mv ./_book/* .
cd ..

