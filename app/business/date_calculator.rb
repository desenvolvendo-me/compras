class DateCalculator
  def initialize(initial_date, days, context, holiday_repository = Holiday)
    @initial_date = initial_date
    @days = days
    @holiday_repository = holiday_repository
    @context = context
  end

  def self.calculate(*args)
    new(*args).calculate
  end

  def calculate
    send "#{context}_day_calculator"
  end

  private

  attr_reader :initial_date, :days, :holiday_repository, :context

  def calendar_day_calculator
    initial_date + days.days
  end

  def working_day_calculator
    counter = 0
    current_date = initial_date

    while counter < days do
      current_date += 1.day

      counter += 1 if working_day?(current_date)
    end

    current_date
  end

  def working_day?(date)
    !date.saturday? && !date.sunday? && !holiday_repository.is_a_holiday?(date)
  end
end
