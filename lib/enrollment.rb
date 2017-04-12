require_relative 'headcount_helper'

class Enrollment

  def initialize(args)
    @args = args
  end

  def kindergarten_participation_by_year
    @args[:kindergarten_participation]
  end

  def kindergarten_participation_in_year(year)
    @args[:kindergarten_participation][year]
  end

  def name
    @args[:name]
  end


end
