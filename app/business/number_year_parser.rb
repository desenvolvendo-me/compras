class NumberYearParser
  attr_accessor :joined_information

  def initialize(joined_information)
    self.joined_information = joined_information
  end

  def number
    self.joined_information.split('/')[0]
  end

  def year
    self.joined_information.split('/')[1]
  end
end
