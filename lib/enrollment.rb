require_relative 'headcount_helper'

class Enrollment

  def initialize(args)
    @args = args
  end

  def kindergarten_participation_by_year
    @args[:kindergarten]
  end

  def kindergarten_participation_in_year(year)
    @args[:kindergarten][year]
  end

  def graduation_rate_by_year
    @args[:high_school_graduation]
  end

  def graduation_rate_in_year(year)
    @args[:high_school_graduation][year]
  end

  def name
    @args[:name]
  end


end
