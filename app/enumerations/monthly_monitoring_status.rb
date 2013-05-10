class MonthlyMonitoringStatus < EnumerateIt::Base
  associate_values :processing, :processed, :cancelled, :processed_with_errors
end
