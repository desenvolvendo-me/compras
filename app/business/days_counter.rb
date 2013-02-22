class DaysCounter
  def initialize(initial_date, end_date, holiday_repository = Holiday)
    @initial_date = initial_date
    @end_date = end_date
    @holiday_repository = holiday_repository
    @days = 0
  end

  def count(context = :calendar)
    self.send("#{context}_days_counter")
    @days
  end

  protected

  attr_reader :initial_date, :end_date, :holiday_repository

  def calendar_days_counter
    each_day { |date| @days += 1 }
  end

  def working_days_counter
    each_day { |date| @days += 1 if util? date }
  end

  def util?(date)
    (!date.saturday? && !date.sunday? && !holiday_repository.is_a_holiday?(date))
  end

  def each_day(&block)
    @days = 0
    (initial_date..end_date).each do |date|
      yield date
    end
  end
end
