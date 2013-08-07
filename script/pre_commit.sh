#!/bin/bash

function checkexit {
  if [ $? -ne 0 ]; then
    exit 1;
  fi
}


echo "PhantomJS version"; phantomjs -v
coffee -v

checkexit

echo 'Brewing the Coffee'
coffee -c ./test/spec
coffee -c ./test/support

checkexit

echo 'Running Phantomjs'
phantomjs ./test/lib/phantom-jasmine/run\_jasmine\_test.coffee ./test/SpecRunner.html

checkexit

echo 'Cleaning up JS'
rm ./test/spec/*.js
rm ./test/support/*.js