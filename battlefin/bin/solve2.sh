#! /bin/bash

nbsecurities=198
nbtraindays=200
nbtestdays=310
passes=20
l1regularization=0
l2regularization=0
loss=quantile

rm target/*.*
echo "computing data..."
ruby src/ruby/datagenerator2.rb $nbsecurities $nbtraindays $nbtestdays data target
echo "data computed"
echo "computing model..."
vw -d target/train.txt -f target/model.vw -c --passes $passes --l1 $l1regularization --l2 $l2regularization --loss_function $loss 2> target/model.vw.out
#vw -d target/train.txt -k --invert_hash target/model.vw.txt -c --passes $passes --l1 $l1regularization --l2 $l2regularization --loss_function $loss 2> target/model.vw.txt.out
echo "model computed"
echo "computing prediction..."
vw -d target/test.txt -t -i target/model.vw -p target/test.prediction 2> target/test.prediction.out
vw -d target/train.txt -t -i target/model.vw -p target/train.prediction 2> target/train.prediction.out
echo "prediction computed"
echo "generating submission file"
#ruby src/ruby/submission.rb $nbsecurities $nbtestdays target
#ruby src/ruby/score.rb $nbsecurities $nbtraindays data target