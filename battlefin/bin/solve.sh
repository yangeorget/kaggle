#! /bin/bash

securities=198
passes=20

rm target/*.*
echo "computing data..."
ruby src/ruby/data.rb $securities
echo "data computed"
for ((i=1; i<=$securities; i++)) do
   security=o$i
   echo "training for security "$security
   vw -d target/$security.train -c --passes $passes -f target/$security.vw > target/$security.train.out
   echo "testing for security "$security
   vw -d target/$security.test -t -i target/$security.vw -p target/$security.prediction > target/$security.test.out
done
echo "generating submission file"
ruby src/ruby/prediction.rb $securities