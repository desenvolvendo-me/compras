class TradingItemClosing < Compras::Model
  attr_accessible :trading_item_id, :status, :reason

  has_enumeration_for :status, :with => TradingItemClosingStatus

  belongs_to :trading_item

  validates :trading_item, :status, :presence => true
end
