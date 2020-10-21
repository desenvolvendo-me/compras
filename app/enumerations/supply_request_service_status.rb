class SupplyRequestServiceStatus < EnumerateIt::Base
  associate_values :new,
                   :order_in_analysis,
                   :order_in_financial_analysis,
                   :returned_for_adjustment,
                   :rejected,
                   :partially_answered,
                   :fully_serviced,
                   :doubts,
                   :adjusted,
                   :finished,
                   :reopen

  def self.non_buyer_user
    to_a.select do |item|
      [DOUBTS, ADJUSTED].include?(item[1])
    end
  end

end
