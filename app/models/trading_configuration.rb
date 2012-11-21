class TradingConfiguration < Compras::Model
  attr_accessible :percentage_limit_to_participate_in_bids

  validates :percentage_limit_to_participate_in_bids,
            :numericality => { :greater_than_or_equal_to => 0, :less_than_or_equal_to => 100 }

  def to_s
    TradingConfiguration.model_name.human
  end
end
