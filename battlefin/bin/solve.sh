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
ruby src/ruby/datagenerator.rb $nbsecurities $nbtraindays $nbtestdays data target
echo "data computed"
for ((i=1; i<=$nbsecurities; i++)) do
   security=o$i
   echo "handling security "$security
   vw -d target/$security.train -f target/$security.vw -c --passes $passes --l1 $l1regularization --l2 $l2regularization --loss_function $loss 2> target/$security.vw.out
   #vw -d target/$security.train -k --invert_hash target/$security.vw.txt -c --passes $passes --l1 $l1regularization --l2 $l2regularization --loss_function $loss 2> target/$security.vw.txt.out
   vw -d target/$security.test -t -i target/$security.vw -p target/$security.test.prediction 2> target/$security.test.prediction.out
   vw -d target/$security.train -t -i target/$security.vw -p target/$security.train.prediction 2> target/$security.train.prediction.out
done
echo "generating submission file"
ruby src/ruby/submission.rb $nbsecurities $nbtestdays target
ruby src/ruby/score.rb $nbsecurities $nbtraindays data target