#! /bin/bash

securities=198
passes=20

rm target/*.*
ruby src/ruby/data.rb $securities
for ((i=1; i<=$securities; i++)) do
   security=o$i
   vw -d target/$security.train -c --passes $passes -f target/$security.vw
   vw -d target/$security.test -t -i target/$security.vw -p target/$security.prediction
done
ruby src/ruby/prediction.rb $securities