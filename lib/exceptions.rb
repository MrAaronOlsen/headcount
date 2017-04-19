class UnknownDataError < StandardError
end

class InsufficientInformationError < StandardError

  def no_grade
    'A grade must be provided to answer this question'
  end
  
end