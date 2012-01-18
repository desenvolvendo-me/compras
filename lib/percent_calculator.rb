class PercentCalculator

  attr_accessor :initial_value, :percent, :final_value

  #
  # The attributes will be 0.0 by default
  #
  def initialize(attributes = {})
    self.initial_value = attributes[:initial_value] ||= 0.0
    self.percent       = attributes[:percent]       ||= 0.0
    self.final_value   = attributes[:final_value]   ||= 0.0
  end

  #
  # Examples:
  #   PercentCalculator(:initial_value => 100.0, :percent => 20.0).subtract_percentage
  #   #=> 80.0
  #
  #   PercentCalculator(:initial_value => -100.0, :percent => 20.0).subtract_percentage
  #   #=> ArgumentError: The initial_value must be equal or greater than 0
  #
  def subtract_percentage
    raise(ArgumentError, 'The initial_value must be equal or greater than 0') if initial_value < 0

    ( initial_value * ( 100.0 - percent ) ) / 100.0
  end

  #
  # Examples:
  #   ParcentCalculator(:initial_value => 200.0, :final_value => 400.0).percent_increase
  #   #=> 100.0
  #
  #   ParcentCalculator(:initial_value => 300.0, :final_value => 200.0).percent_increase
  #   #=> ArgumentError: The final_value must be equal or greater than the initial_value or try use percent_decrease method
  #
  def percent_increase
    raise(ArgumentError, "The final_value must be equal or greater than the initial_value or try use percent_decrease method") unless final_value >= initial_value

    return 0.0 if equal_values?

    ( 100.0 * initial_value ) / ( final_value - initial_value )
  end

  #
  # Examples:
  #   ParcentCalculator(:initial_value => 200.0, :final_value => 100.0).percent_decrease
  #   #=> 50.0
  #
  #   ParcentCalculator(:initial_value => 100.0, :final_value => 200.0).percent_decrease
  #   #=> ArgumentError: The initial_value must be equal or greater than the final_value or try use percent_increase method
  #
  def percent_decrease
    raise(ArgumentError, "The initial_value must be equal or greater than the final_value or try use percent_increase method") unless initial_value >= final_value

    return 0.0 if equal_values?

    100 - ( ( 100.0 * final_value ) / initial_value )
  end

  private

  def equal_values?
    initial_value == final_value
  end
end
