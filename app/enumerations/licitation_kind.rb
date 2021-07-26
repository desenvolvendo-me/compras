class LicitationKind < EnumerateIt::Base
  associate_values :lowest_price,
                   :best_technique,
                   :technical_and_price,
                   :best_auction_or_offer,
                   :higher_discount_on_item,
                   :higher_discount_on_lot,
                   :higher_discount_on_table
end
