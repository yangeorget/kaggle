#! /bin/bash

nbsecurities=198
nbtraindays=200
nbtestdays=310
passes=100
l1regularization=0
loss=quantile

rm target/*.*
echo "computing data..."
ruby src/ruby/model.rb $nbsecurities $nbtraindays $nbtestdays data target
echo "data computed"
for ((i=1; i<=$nbsecurities; i++)) do
   security=o$i
   echo "handling security "$security
   vw -d target/$security.train -c --passes $passes -f target/$security.vw --l1 $l1regularization --loss_function $loss 2> target/$security.train.out
   vw -d target/$security.test -t -i target/$security.vw -p target/$security.prediction 2> target/$security.test.out
   vw -d target/$security.train -c --passes $passes -k --invert_hash target/$security.model --l1 $l1regularization --loss_function $loss 2> target/$security.model.out
done
echo "generating submission file"
ruby src/ruby/prediction.rb $nbsecurities $nbtestdays target