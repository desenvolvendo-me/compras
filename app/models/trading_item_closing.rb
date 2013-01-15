class TradingItemClosing < Compras::Model
  attr_accessible :trading_item_id, :status, :reason

  has_enumeration_for :status, :with => TradingItemClosingStatus,
                      :create_helpers => true

  belongs_to :trading_item

  validates :trading_item, :status, :presence => true
  validate :save_with_winner

  private

  def save_with_winner
    return unless winner?

    unless trading_item.allow_winner?
      errors.add(:status, :trading_item_has_not_a_winner)
    end
  end
end
