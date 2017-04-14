require_relative 'headcount_helper'

class Enrollment

  def initialize(args)
    @args = args
  end

  def kindergarten_participation_by_year
    if @args[:kindergarten].nil?
      @args[:kindergarten_participation]
    else
      @args[:kindergarten]
    end
  end

  def kindergarten_participation_in_year(year)
    if @args[:kindergarten].nil?
      @args[:kindergarten_participation][year]
    else
      @args[:kindergarten][year]
    end
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
