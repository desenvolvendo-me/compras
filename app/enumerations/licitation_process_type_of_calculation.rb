class LicitationProcessTypeOfCalculation < EnumerateIt::Base
  associate_values :lowest_total_price_by_item,
                   :lowest_global_price,
                   :lowest_price_by_lot,
                   :sort_participants_by_item,
                   :sort_participants_by_lot,
                   :highest_bidder_by_item,
                   :highest_bidder_by_lot
end
