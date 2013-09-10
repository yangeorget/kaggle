require 'csv'

nbdays = 510
traindays = 1..200
testdays = 201..nbdays
timestamps = 55
securities = ARGV[0].to_i
features = 244

data = Array.new(nbdays)
for day in 1..nbdays
  data[day-1] = CSV.read("data/" + day.to_s + ".csv")
end
trainLabels = CSV.read("trainLabels.csv")

for sec in 1..securities
  File.open("target/o"+ sec.to_s + ".train", 'w') do |train|
    for day in traindays
      train.write(trainLabels[day][sec]) # indices are correct!
      train.write(" | ")
      for ts in 1..timestamps
        train.write("o" + sec.to_s + "_" + ts.to_s)
        train.write(":")
        train.write(data[day-1][ts][sec-1])
        train.write(" ")
      end
      train.write("day:")
      train.write(day.to_s)
      train.write("\n")
    end
  end
  File.open("target/o"+ sec.to_s + ".test", 'w') do |test|
    for day in testdays
      test.write("0.0 | ")
      for ts in 1..timestamps
        test.write("o" + sec.to_s + "_" + ts.to_s)
        test.write(":")
        test.write(data[day-1][ts][sec-1])
        test.write(" ")
      end
      test.write("day:")
      test.write(day.to_s)
      test.write("\n")
    end
  end
end


def line(file, value, day, sec)
  train.write(value)
      train.write(" | ")
      for ts in 1..timestamps
        train.write("o" + sec.to_s + "_" + ts.to_s)
        train.write(":")
        train.write(data[day-1][ts][sec-1])
        train.write(" ")
      end
      train.write("day:")
      train.write(day.to_s)
      train.write("\n")
    end
end