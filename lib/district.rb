

require_relative 'headcount_helper'

class District

  attr_reader :name

  def initialize(args)
    @name = args[:name]
  end
end
