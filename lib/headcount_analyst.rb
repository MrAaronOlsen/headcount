require_relative 'headcount_helper'

class HeadcountAnalyst

  def initialize(district_repository)
    @repo = district_repository
  end

  def find_by_name(name)
    @repo.find_by_name(name)
  end

# enrollment analyst

  def kindergarten_participation_rate_variation(loc_1, loc_2)
    compare = [loc_1, loc_2[:against]].map do |name|
      find_by_name(name).enrollment.kindergarten_participation_by_year
    end

    average(compare[0].values) / average(compare[1].values)
  end

  def kindergarten_participation_rate_variation_trend(loc_1, loc_2)
    compare = [loc_1, loc_2[:against]].map do |name|
      find_by_name(name).enrollment.kindergarten_participation_by_year
    end

    matched = match_data(compare[0], compare[1])
    matched[0].merge(matched[1]) { |date, data1, data2| data1 / data2 }
  end

  def high_school_graduation_rate_variation(loc_1, loc_2)
    compare = [loc_1, loc_2[:against]].map do |name|
      find_by_name(name).enrollment.graduation_rate_by_year
    end

    average(compare[0].values) / average(compare[1].values)
  end

  def high_school_graduation_rate_variation_trend(loc_1, loc_2)
    compare = [loc_1, loc_2[:against]].map do |name|
      find_by_name(name).enrollment.graduation_rate_by_year
    end

    matched = match_data(compare[0], compare[1])
    matched[0].merge(matched[1]) { |date, data1, data2| data1 / data2 }
  end

  def kindergarten_participation_against_high_school_graduation(loc)
    kindergarten_participation_rate_variation(loc, against: 'COLORADO')/
    high_school_graduation_rate_variation(loc, against: 'COLORADO')
  end

  alias :kp_v_hsg
    :kindergarten_participation_against_high_school_graduation

  def kindergarten_participation_correlates_with_high_school_graduation(loc)
    loc[:across], loc[:for] = @repo.all_names, nil if loc[:for] == 'STATEWIDE'

    if loc[:across].nil?
      correlation? kp_v_hsg(loc[:for])
    else
      predict?(
        percent_of_range loc[:across].map { |loc| kp_cor_hsg(for: loc) }, true
      )
    end
  end

  alias :kp_cor_hsg
    :kindergarten_participation_correlates_with_high_school_graduation

# statewide analyst

 def top_statewide_test_year_over_year_growth(args)
   query = {grade: args[:grade], subject: args[:subject]}
   query[:top] = args[:top] || 1

   raise InsufficientInformationError.new if query[:grade].nil?
   raise UnknownDataError.new unless [3, 8].include?(query[:grade])

   if query[:subject].nil?
     find_top_growth_by_grade(query[:grade])
   else
     find_top_growth_by_grade_subject(query[:grade], query[:subject], query[:top])
   end
 end

 def find_top_growth_by_grade(grade)
   all_subject = collect_growth_across_all_subjects(grade)
   grouped = all_subject.flatten(1).group_by { |line| line[0] }
   averaged = grouped.hash_map do |dist, data|
     { dist => average(data.map { |pair| pair[1] }) }
   end

   averaged.max_by { |line| line[1] }
 end

 def collect_growth_across_all_subjects(grade)
   [:math, :reading, :writing].map do |subject|
     find_growth_by_grade_subject(grade, subject)
   end
 end

 def find_top_growth_by_grade_subject(grade, subject, top = 1)
   results = find_growth_by_grade_subject(grade, subject)
   if top == 1 then results[-1] else results[-top..-1] end
 end

 def find_growth_by_grade_subject(grade, subject)
   by_grade = collect_districts_by_grade(grade)
   scrubbed = scrub_invalid_data_by_subject(by_grade, subject)
   minmax = collect_districts_by_minmax_year(scrubbed)
   growths = find_growths_by_subject(minmax, subject)
   growths.sort_by { |dist, growth| growth }
 end

 def collect_districts_by_grade(grade)
   @repo.districts.hash_map do |dist|
     {dist.name => dist.statewide_test.proficient_by_grade(grade)}
   end
 end

 def collect_districts_by_minmax_year(data_set)
   data_set.hash_map do |dist, data_set|
     {dist => data_set.minmax_by { |year, subjects| year }.to_h }
   end
 end

 def scrub_invalid_data_by_subject(data_sets, subject)
   data_sets.delete_if do |district, data_set|
     data_set.delete_if do |date, subjects|
       invalid_data?(subjects[subject])
     end.length < 2
   end
 end

 def find_growths_by_subject(data_set, subject)
   data_set.hash_map do |dist, data_set|
     {dist => calc_growth(data_set, subject)}
   end
 end

 def calc_growth(data_set, subject)
   sorted = data_set.sort

   (sorted[1][1][subject] - sorted[0][1][subject]) /
           (sorted[1][0] - sorted[0][0])
 end

 def invalid_data?(data)
   data.is_a? String
 end

# helper methods

  def predict?(percentage)
    percentage > 70.0
  end

  def correlation?(percentage)
    percentage >= 0.6 && percentage <= 1.5
  end

  def percent(num1, num2)
    return num1 if num2.zero?
    (num1.to_f / num2) * 100
  end

  def percent_of_range(range, arg)
    percent range.count(arg), range.count
  end

  def average(data)
    return 0 if data.length < 2
    data.reduce(0) { |sum, data| sum + data } / data.length
  end

  def match_data(first, second)
      [ first.select { |key| second.include?(key) },
      second.select { |key| first.include?(key) } ]
  end

end