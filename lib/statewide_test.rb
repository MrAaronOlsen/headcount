require_relative 'unknown_data_error'
require_relative 'unknown_race_error'
require_relative 'headcount_helper'

class StatewideTest
  attr_reader :args
  def initialize(args)
    @args = args
  end

  def name
    @args[:name]
  end

  def proficient_by_grade(grade)
     if grade == 3
       @args[:third_grade]
     elsif grade == 8
       @args[:eighth_grade]

     else
       raise UnknownDataError
     end
   end

    def proficient_by_race_or_ethnicity(race)
    end

    def proficient_for_subject_by_grade_in_year(subject, grade, year)
    end

    def proficient_for_subject_by_race_in_year(subject, race, year)
    end
end
