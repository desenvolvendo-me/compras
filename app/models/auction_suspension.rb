class AuctionSuspension < Compras::Model
  attr_accessible :suspension_date, :responsible_suspension_id, :reactivation_date,
                  :responsible_reactivation_id, :auction_id, :suspension_reason,
                  :reactivation_reason

  belongs_to :responsible_suspension, class_name: 'User'
  belongs_to :responsible_reactivation, class_name: 'User'
  belongs_to :auction, class_name: 'Auction'

  validates :auction, :suspension_date, :suspension_reason, :responsible_suspension_id, presence: true
  validates :reactivation_date, :reactivation_reason, :responsible_reactivation_id, presence: true, unless: :reactivation?


  def reactivation?
    reactivation_reason.blank? and reactivation_date.blank?
  end
end
