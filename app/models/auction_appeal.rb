class AuctionAppeal < Compras::Model
  attr_accessible :auction_id, :appeal_date, :related, :person_id, :valid_reason,
                  :new_envelope_opening_date, :new_envelope_opening_time,
                  :auction_committee_opinion, :situation

  has_enumeration_for :related, :with => PurchaseProcessAppealRelated
  has_enumeration_for :situation

  belongs_to :auction
  belongs_to :person

  delegate :description, :process_date,
           :to => :auction, :allow_nil => true, :prefix => true

  validates :auction, :creditor, :presence => true

  # validates :appeal_date, :timeliness => {
  #     :on_or_after => :auction_date,
  #     :on_or_after_message => :must_be_greater_or_equal_to_auction_date,
  #     :type => :date,
  #     :allow_blank => true
  # }

  orderize :appeal_date
  filterize

  def to_s
    "#{auction} - #{I18n.l(appeal_date)}"
  end
end