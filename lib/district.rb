

require_relative 'headcount_helper'

class District

  attr_reader :name, :repositories

  def initialize(args)
    @name = args[:name]
    @repositories = []
  end

  def enrollment
    @repositories.find { |repo| repo.is_a? Enrollment }
  end

  def statewide_test
    @repositories.find { |repo| repo.is_a? StatewideTest }
  end

  def economic_profile
    @repositories.find { |repo| repo.is_a? EconomicProfile }
  end

end
