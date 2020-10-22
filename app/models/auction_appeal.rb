class AuctionAppeal < Compras::Model
  attr_accessible :auction_id, :appeal_date, :related, :person_id, :valid_reason,
                  :new_envelope_opening_date, :new_envelope_opening_time,
                  :auction_committee_opinion, :situation, :viewed, :appeal_file,
                  :opening_date, :opening_time, :closure_date, :closure_time

  has_enumeration_for :related, :with => PurchaseProcessAppealRelated
  has_enumeration_for :situation

  mount_uploader :appeal_file, UnicoUploader

  belongs_to :auction
  belongs_to :person

  delegate :object, :process_date,
           :to => :auction, :allow_nil => true, :prefix => true

  validates :auction, :person, :presence => true

  before_save :set_situation, if: :envelope_open?

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

  def mark_as_viewed
    self.viewed = true
    self.save
  end


  private
  def envelope_open?
    new_envelope_opening_date && new_envelope_opening_time
  end

  def set_situation
    self.situation = Situation::DEFERRED
  end
end