class SupplyOrderStatus < EnumerateIt::Base
  associate_values :sent, :partially_answered, :fully_serviced, :pending_delivery, :partially_answered

end
