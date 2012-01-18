class BusinessDay
  attr_accessor :date

  def initialize(date)
    self.date = date
  end

  def next_business_day
    self.date = date + 1 while weekend?

    date
  end

  def previous_business_day
    self.date = date - 1 while weekend?

    date
  end

  protected

  def weekend?
    saturday? || sunday?
  end

  def saturday?
    date.wday == 0
  end

  def sunday?
    date.wday == 6
  end
end
