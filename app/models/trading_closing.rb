class TradingClosing < Compras::Model
  attr_accessible :trading_id, :status, :observation

  has_enumeration_for :status, :with => TradingClosingStatus

  belongs_to :trading

  validates :status, :trading, :presence => true

  orderize "id DESC"

  def to_s
    "#{trading} - #{status_humanize}"
  end
end
