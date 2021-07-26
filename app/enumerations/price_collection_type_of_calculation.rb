class PriceCollectionTypeOfCalculation < EnumerateIt::Base
  associate_values :lowest_total_price_by_item,
                   :lowest_global_price,
                   :lowest_price_by_lot
end
