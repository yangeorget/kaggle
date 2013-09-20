#! /bin/bash

nbsecurities=198
nbtraindays=200
nbtestdays=310
passes=20
l1regularization=0.001
l2regularization=0.001
loss=quantile

rm target/*.*
echo "computing data..."
ruby src/ruby/datagenerator3.rb $nbsecurities $nbtraindays $nbtestdays data target
echo "data computed"
echo "generating submission file"
ruby src/ruby/submission3.rb $nbsecurities $nbtestdays target
