

require_relative 'headcount_helper'

class District

  attr_accessor :enrollment

  attr_reader :name

  def initialize(args)
    @name = args[:name]
    @enrollment = "nothing"
  end

end
