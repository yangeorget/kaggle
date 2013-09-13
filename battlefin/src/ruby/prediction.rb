require 'csv'

class Prediction
  def initialize(nbsecurities, nbtestdays, outfolder)
    @nbsecurities = nbsecurities
    @nbtestdays = nbtestdays
    @outfolder = outfolder
  end

  def run
    CSV.open(@outfolder + "/submission.txt", 'w') do |prediction|
      prediction << ["FileId"] + (1..@nbsecurities).to_a.map{ |sec| "O" + sec.to_s}
      output = Array.new(@nbsecurities + 1)
      output[0] = (201..200+@nbtestdays).to_a
      for sec in 1..@nbsecurities
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
