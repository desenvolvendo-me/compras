class IntervalCalculation
  attr_accessor :date, :interval_type, :interval_number

  # Returns a new date calculated by an interval type and interval number
  #
  # ==== Parameters
  # date<Date>:: Date to be changed.
  #
  # ==== Options
  # interval_type<String>:: Interval type that will be increased. Must be one of this: (Day, Month, Year)
  # interval_number<Fixnum>:: Interval day that will be increased.
  #
  #
  def initialize(date, options={})
    self.date = date
    self.interval_type   = options[:interval_type]
    self.interval_number = options[:interval_number]
  end

  # Prolongate the date depending on interval type and interval number
  #
  def prolongate
    date + interval_number.send(interval_type)
  end
end
