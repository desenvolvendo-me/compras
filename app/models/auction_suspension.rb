class AuctionSuspension < Compras::Model
  attr_accessible :suspension_date, :responsible_suspension_id, :reactivation_date,
                  :responsible_reactivation_id, :auction_id, :suspension_reason,
                  :reactivation_reason

  belongs_to :responsible_suspension, class_name: 'User'
  belongs_to :responsible_reactivation, class_name: 'User'
  belongs_to :auction, class_name: 'Auction'

  validates :auction, :suspension_date, :suspension_reason, :responsible_suspension_id, presence: true
  validates :reactivation_date, :reactivation_reason, :responsible_reactivation_id, presence: true, unless: :reactivation?

  after_save :set_auction_suspended, unless: :reactivation?
  after_save :set_auction_reactivated, if: :reactivation?

  def reactivation?
    reactivation_reason.blank? and reactivation_date.blank?
  end

  private

  def update_auction_status
    auction.update(status: AuctionStatus::SUSPENDED)
  end

  def set_auction_reactivated
    auction.update(status: AuctionStatus::REACTIVATED)
  end
end
