class DeliveryScheduleStatus < EnumerateIt::Base
  associate_values :expired, :to_expire, :delivered
end
