require_relative 'lib/headcount_helper'
require_relative 'lib/enums'

@data_sets = {
  math:
   [{location: 'Colorado', race_ethnicity: 'All Students', timeframe: '2011', dataformat: 'Percent', data: '0.5573'},
    {location: 'Colorado', race_ethnicity: 'Asian', timeframe: '2011', dataformat: 'Percent', data: '0.7094'},
    {location: 'Colorado', race_ethnicity: 'Black', timeframe: '2011', dataformat: 'Percent', data: '0.3333'},
    {location: 'Colorado', race_ethnicity: 'All Students', timeframe: '2012', dataformat: 'Percent', data: '0.5573'},
    {location: 'Colorado', race_ethnicity: 'Asian', timeframe: '2012', dataformat: 'Percent', data: '0.7094'},
    {location: 'Colorado', race_ethnicity: 'Black', timeframe: '2012', dataformat: 'Percent', data: '0.3333'}],
  reading:
   [{location: 'Colorado', race_ethnicity: 'All Students', timeframe: '2011', dataformat: 'Percent', data: '0.68'},
    {location: 'Colorado', race_ethnicity: 'Asian', timeframe: '2011', dataformat: 'Percent', data: '0.7482'},
    {location: 'Colorado', race_ethnicity: 'Black', timeframe: '2011', dataformat: 'Percent', data: '0.4861'},
    {location: 'Colorado', race_ethnicity: 'All Students', timeframe: '2012', dataformat: 'Percent', data: '0.68'},
    {location: 'Colorado', race_ethnicity: 'Asian', timeframe: '2012', dataformat: 'Percent', data: '0.7482'},
    {location: 'Colorado', race_ethnicity: 'Black', timeframe: '2012', dataformat: 'Percent', data: '0.4861'}],
  writing:
   [{location: 'Colorado', race_ethnicity: 'All Students', timeframe: '2011', dataformat: 'Percent', data: '0.5531'},
    {location: 'Colorado', race_ethnicity: 'Asian', timeframe: '2011', dataformat: 'Percent', data: '0.6569'},
    {location: 'Colorado', race_ethnicity: 'Black', timeframe: '2011', dataformat: 'Percent', data: '0.3701'},
    {location: 'Colorado', race_ethnicity: 'All Students', timeframe: '2012', dataformat: 'Percent', data: '0.5531'},
    {location: 'Colorado', race_ethnicity: 'Asian', timeframe: '2012', dataformat: 'Percent', data: '0.6569'},
    {location: 'Colorado', race_ethnicity: 'Black', timeframe: '2012', dataformat: 'Percent', data: '0.3701'}]
}


def proficient_by_race_or_ethnicity(race)
  collect_by_date(race)
end

def collect_by_date(race)
  parsed = {}
  @data_sets.each do |type, data_set|
    data_set.each do |line|
      parsed[line[:timeframe]] = collect_by_score(race)
      end
    end
  parsed
end

def collect_by_score(race)
  collected = {}
  @data_sets.each do |type, data_set|
    data_set.each do |line|
      collected[type] = line[:data] if line[:race_ethnicity].downcase.gsub(' ', '_').to_sym == race
      end
    end
  collected
end

done = proficient_by_race_or_ethnicity(:asian)

done.each { |date, data| puts "#{date} #{data}" }