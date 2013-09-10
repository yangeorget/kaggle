require 'csv'

class DataGenerator
  def initialize(securities, nbtraindays, nbtestdays)
    @securities = securities
    @nbtraindays = nbtraindays
    @nbtestdays = nbtestdays
    @timestamps = 55
    @features = 244
    @traindata = Array.new(@nbtraindays)
    for day in 0..@nbtraindays-1
      @traindata[day] = CSV.read("data/" + (1 + day).to_s + ".csv")
    end
    @testdata = Array.new(@nbtestdays)
    for day in 0..@nbtestdays-1
      @testdata[day] = CSV.read("data/" + (201 + day).to_s + ".csv")
    end
    @trainLabels = CSV.read("trainLabels.csv")
  end

  def line(file, data, value, day, sec)
    file.write(value)
    file.write(" | ")
    for ts in 1..@timestamps
      file.write("o" + sec.to_s + "_" + ts.to_s)
      file.write(":")
      file.write(data[day][ts][sec-1])
      file.write(" ")
    end
    file.write("day:")
    file.write(day.to_s)
    file.write("\n")
  end

  def run
    for sec in 1..@securities
      File.open("target/o"+ sec.to_s + ".train", 'w') do |train|
        for day in 0..@nbtraindays-1
          line(train, @traindata, @trainLabels[day+1][sec], day, sec) # indices are correct!
        end
      end
      File.open("target/o"+ sec.to_s + ".test", 'w') do |test|
        for day in 0..@nbtestdays-1
          line(test, @testdata, "0.0", day, sec)
        end
      end
    end
  end
end

DataGenerator.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i).run
