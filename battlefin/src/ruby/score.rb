require 'csv'

class Score
  def initialize(nbsecurities, nbtraindays, infolder, outfolder)
    @nbsecurities = nbsecurities
    @nbtraindays = nbtraindays
    @outfolder = outfolder
    @trainLabels = CSV.read(infolder + "/" + "trainLabels.csv")
  end

  def run
    error = 0.0
    for sec in 1..@nbsecurities
      results = CSV.read(@outfolder + "/o" + sec.to_s + ".train.prediction").flatten
      for day in 1..@nbtraindays
        error += (@trainLabels[day][sec].to_f - results[day-1].to_f).abs
      end
    end
    puts error / @nbsecurities.to_i / @nbtraindays.to_i
  end
end

if __FILE__ == $PROGRAM_NAME
  Score.new(ARGV[0].to_i, ARGV[1].to_i, ARGV[2], ARGV[3]).run
end
