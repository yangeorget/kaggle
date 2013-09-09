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
      line(train, day, trainLabels[day][sec], sec)
    end
  end
  File.open("target/o"+ sec.to_s + ".test", 'w') do |test|
    for day in testdays
      line(test, day, "0.0", sec)
    end
  end
end

def line(file, day, trainValue, sec)
      file.write(trainValue)
      file.write(" | ")
      for ts in 1..timestamps
        file.write("o" + sec.to_s + "_" + ts.to_s)
        file.write(":")
        file.write(data[day-1][ts][sec-1])
        file.write(" ")
      end
      file.write("day:")
      file.write(day.to_s)
      file.write("\n")
end
