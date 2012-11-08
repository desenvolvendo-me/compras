class TradingItem < Compras::Model
  attr_accessible :detailed_description, :minimum_reduction_percent,
                  :minimum_reduction_value, :order,
                  :administrative_process_budget_allocation_item_id

  belongs_to :trading
  belongs_to :administrative_process_budget_allocation_item

  has_many :trading_item_bids, :dependent => :destroy, :order => :id
  has_many :bidders, :through => :trading, :order => :id

  validates :minimum_reduction_percent, :numericality => { :equal_to  => 0.0 },
            :if => :minimum_reduction_value?
  validates :minimum_reduction_value, :numericality => { :equal_to  => 0.0 },
            :if => :minimum_reduction_percent?
  validates :minimum_reduction_percent, :numericality => { :less_than_or_equal_to => 100 }

  delegate :material, :material_id, :reference_unit,
           :quantity, :unit_price, :to_s,
           :to => :administrative_process_budget_allocation_item,
           :allow_nil => true
  delegate :licitation_process_id, :to => :trading

  orderize :order

  def last_proposal_value
    last_bid_with_proposal.try(:amount) || 0
  end

  def last_bid_round
    last_bid.try(:round) || 0
  end

  end

  private

  def last_bid
    trading_item_bids.last
  end

  def last_bid_with_proposal
    trading_item_bids.with_proposal.last
  end
end
