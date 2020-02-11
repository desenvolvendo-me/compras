class SupplyRequestServiceStatus < EnumerateIt::Base
  associate_values :order_in_analysis, :returned_for_adjustment, :rejected, :partially_answered, :fully_serviced

end
