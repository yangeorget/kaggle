#! /bin/bash

securities=198
nbtraindays=200
nbtestdays=310
passes=20

rm target/*.*
echo "computing data..."
ruby src/ruby/data.rb $securities $nbtraindays $nbtestdays
echo "data computed"
for ((i=1; i<=$securities; i++)) do
   security=o$i
   echo "training for security "$security
   vw -d target/$security.train -c --passes $passes -f target/$security.vw 2> target/$security.train.out
   echo "testing for security "$security
   vw -d target/$security.test -t -i target/$security.vw -p target/$security.prediction 2> target/$security.test.out
done
echo "generating submission file"
ruby src/ruby/prediction.rb $securities $nbtraindays $nbtestdays