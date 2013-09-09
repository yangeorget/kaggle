require 'csv'

testdays = 201..510
securitiesnb = ARGV[0].to_i
securities = 1..securitiesnb

CSV.open("target/prediction.txt", 'w') do |prediction|
  r = Array.new()
  r[0] = "FileId"
  i = 1
  for sec in securities
    r[i] = "O" + sec.to_s
    i = i +1
  end
  prediction << r
  output = Array.new(securitiesnb +1)
  output[0] = testdays.to_a
  for sec in securities
    output[sec] = CSV.read("target/o" + sec.to_s + ".prediction").flatten
  end
  output = output.transpose
  for row in output
    prediction << row
  end
end
