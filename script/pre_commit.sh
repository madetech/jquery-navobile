#!/bin/bash

function checkexit {
  if [ $? -ne 0 ]; then
    exit 1;
  fi
}


echo "PhantomJS version"; phantomjs -v
coffee -v

echo 'Brewing the Coffee'
coffee -c ./test/spec
coffee -c ./test/support

echo 'Running Phantomjs'
phantomjs ./test/lib/phantom-jasmine/run\_jasmine\_test.coffee ./test/SpecRunner.html