require 'csv'

class DataGenerator2
  def initialize(nbsecurities, nbtraindays, nbtestdays, infolder, outfolder)
    @nbsecurities = nbsecurities
    @nbtraindays = nbtraindays
    @nbtestdays = nbtestdays
    @infolder = infolder
    @outfolder = outfolder
    @nbtimestamps = 55
    @nbfeatures = 244
    @traindata = Array.new(@nbtraindays)
    puts "reading from " + @infolder
    puts "writing to " + @outfolder
    for day in 0..@nbtraindays-1
      puts "reading train data for day " + day.to_s
      @traindata[day] = CSV.read(@infolder + "/" + (1 + day).to_s + ".csv")
    end
    @testdata = Array.new(@nbtestdays)
    for day in 0..@nbtestdays-1
      puts "reading test data for day " + day.to_s
      @testdata[day] = CSV.read(@infolder + "/" + (201 + day).to_s + ".csv")
    end
    puts "reading trainLabels"
    @trainLabels = CSV.read(@infolder + "/" + "trainLabels.csv")
    puts "done reading data"
  end

  def self.emit(file, key, value)
      file.write(key)
      file.write(":")
      file.write(value.to_s)
      file.write(" ")
  end

  def line(file, data, value, day, sec)
    file.write(value)
    file.write(" | ")
    DataGenerator2.emit(file, "day", day)
    DataGenerator2.emit(file, "sec", sec)
    for ts in 1..@nbtimestamps
      DataGenerator2.emit(file, "ts" + ts.to_s, data[day][ts][sec-1])
    end
    for feat in 1..@nbfeatures
      DataGenerator2.emit(file, "I" + feat.to_s+ "_last", data[day][@nbtimestamps][@nbsecurities+feat-1])
    end
    file.write("\n")
  end

  def run
    puts "generating train.txt"
    File.open(@outfolder + "/train.txt", 'w') do |train|
      for sec in 1..@nbsecurities
        for day in 0..@nbtraindays-1
          line(train, @traindata, @trainLabels[day+1][sec], day, sec) # indices are correct!
        end
      end
    end
    puts "generating test.txt"
    File.open(@outfolder + "/test.txt", 'w') do |test|
      for sec in 1..@nbsecurities
        for day in 0..@nbtestdays-1
          line(test, @testdata, "0.0", day, sec)
        end
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  DataGenerator2.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i, ARGV[3], ARGV[4]).run
end
