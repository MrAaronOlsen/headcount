require_relative 'lib/headcount_helper'
def variable_key
  if data_set.include?(:score)
      :score
  else
      :race_ethnicity
  end
end

a = [{location: "Colorado", score: "Math", timeframe: "2008", dataformat: "Percent", data: "0.697"},
{location: "Colorado", score: "Reading", timeframe: "2008", dataformat: "Percent", data: "0.703"},
{location: "Colorado", score: "Writing", timeframe: "2008", dataformat: "Percent", data: "0.501"},
{location: "Colorado", score: "Math", timeframe: "2009", dataformat: "Percent", data: "0.697"},
{location: "Colorado", score: "Reading", timeframe: "2009", dataformat: "Percent", data: "0.703"},
{location: "Colorado", score: "Writing", timeframe: "2009", dataformat: "Percent", data: "0.501"}]


def collect_data(name, data_set)
  temp = {}
  data_set.each do |line|
      temp[line[:timeframe].to_i] = collect_scores(data_set, line[:timeframe], name) if line[:location] == name
  end
  temp
end

def collect_scores(data_set, date, name)
  score_hash = {}
  data_set.each do |line|
    score_hash[line[:score]] = line[:data].to_f if line[:timeframe] == date && line[:location] == name
  end
  score_hash
end

puts collect_data("Colorado",  a)
