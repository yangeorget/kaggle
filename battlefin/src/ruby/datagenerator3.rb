require 'csv'

class DataGenerator
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
    #for day in 0..@nbtraindays-1
    #  puts "reading train data for day " + day.to_s
    #  @traindata[day] = CSV.read(@infolder + "/" + (1 + day).to_s + ".csv")
    #end
    @testdata = Array.new(@nbtestdays)
    for day in 0..@nbtestdays-1
      puts "reading test data for day " + day.to_s
      @testdata[day] = CSV.read(@infolder + "/" + (201 + day).to_s + ".csv")
    end
    puts "reading trainLabels"
    # @trainLabels = CSV.read(@infolder + "/" + "trainLabels.csv")
  end

  def line(file, data, value, day, sec)
    file.write(data[day][@nbtimestamps][sec-1])
    file.write("\n")
  end

  def run
    for sec in 1..@nbsecurities
      #File.open(@outfolder + "/o"+ sec.to_s + ".train", 'w') do |train|
      #  for day in 0..@nbtraindays-1
      #    line(train, @traindata, @trainLabels[day+1][sec], day, sec) # indices are correct!
      #  end
      #end
      File.open(@outfolder + "/o"+ sec.to_s + ".test", 'w') do |test|
        for day in 0..@nbtestdays-1
          line(test, @testdata, "0.0", day, sec)
        end
      end
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  DataGenerator.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2].to_i, ARGV[3], ARGV[4]).run
end
