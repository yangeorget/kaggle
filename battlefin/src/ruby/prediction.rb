require 'csv'

class Prediction
  def initialize(securities, nbtestdays, outfolder)
    @securities = securities
    @nbtestdays = nbtestdays
    @outfolder = outfolder
  end

  def run
    CSV.open(@outfolder + "/submission.txt", 'w') do |prediction|
      r = Array.new
      r[0] = "FileId"
      i = 1
      for sec in 1..@securities
        r[i] = "O" + sec.to_s
        i = i +1
      end
      prediction << r
      output = Array.new(@securities + 1)
      output[0] = (201..200+@nbtestdays).to_a
      for sec in 1..@securities
        output[sec] = CSV.read(@outfolder + "/o" + sec.to_s + ".prediction").flatten
      end
      output = output.transpose
      for row in output
        prediction << row
      end
    end
  end
end

Prediction.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2]).run
