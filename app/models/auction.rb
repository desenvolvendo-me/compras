class Auction < Compras::Model
  attr_accessible :auction_type, :process_number, :year, :dispute_type, :zip_code,
                  :covid_law, :purchase_value, :items_quantity, :group_items_attributes,
                  :object_management, :employee_id, :items_attributes, :sensitive_value, :licitation_process_id,
                  :decree_treatment, :document_edict, :disclosure_date, :responsible_dissemination_id, :notice_availability,
                  :proposal_delivery, :bid_opening, :internet_address, :city, :chat_activated, :status,
                  :neighborhood, :street, :telephone, :cell_phone, :user_id, :bid_opening_time,
                  :end_dispute_date, :end_dispute_time, :restart_dispute_date, :restart_dispute_time

  attr_modal :process, :process_number, :proposal_delivery, :bid_opening, :description

  belongs_to :licitation_process
  belongs_to :employee
  belongs_to :user
  belongs_to :responsible_dissemination, class_name: "Employee"

  has_many :group_items, class_name: "AuctionGroupItem"

  has_many :auction_support_teams
  has_many :bids, class_name: 'AuctionBid'


  has_one :appeal, class_name: 'AuctionAppeal'
  has_one :suspension, class_name: 'AuctionSuspension'
  has_one :conversation, class_name: 'AuctionConversation'

  delegate :year, :process, :judgment_form, :description, to: :licitation_process, allow_nil: true

  mount_uploader :document_edict, UnicoUploader

  has_enumeration_for :auction_type, :with => AuctionType
  has_enumeration_for :dispute_type, :with => AuctionDisputeType
  # has_enumeration_for :judment_form, :with => AuctionJudmentForm
  has_enumeration_for :status, :with => AuctionStatus


  accepts_nested_attributes_for :group_items, :allow_destroy => true
  accepts_nested_attributes_for :auction_support_teams, :allow_destroy => true

  # validates :bid_opening, :bid_opening_time, presence: true
  # validates :zip_code, mask: "99999-999", allow_blank: true
  # validates :cell_phone, mask: "(99) 99999-9999", :allow_blank => true
  # validates :telephone, mask: "(99) 9999-9999", :allow_blank => true
  validates :licitation_process_id, :dispute_type, :employee_id, presence: true

  before_save :clear_session_status
  after_create :create_conversation

  def self.ordered
    order("notice_availability >= '#{Date.today}', notice_availability ASC, proposal_delivery >= '#{Date.today}', notice_availability ASC")
  end

  filterize


  scope :term, lambda {|q|
    joins(:licitation_process).where{ licitation_process.process.matches "%#{q}%" }
  }

  def to_s
    "#{process}/#{year}"
  end


  def creditor_proposal (creditor_id)
    creditor_proposals.includes(:auction_creditor_proposal_items).find_by_creditor_id(creditor_id)
  end

  def minimum_proposal_item item_id
    auction_creditor_proposal_items.where(auction_item_id: item_id).minimum(:global_price)
  end

  def session_ended?
    end_dispute_date.present? && end_dispute_time.present?
  end

  def session_restarted?
    restart_dispute_date.present? && restart_dispute_time.present?
  end

  def suspended?
    suspension.present? && suspension.reactivation?
  end

  def reactivated?
    suspension.present? && !suspension.reactivation?
  end

  private
  def clear_session_status
    if end_dispute_date_changed? and end_dispute_time_changed?
      self.restart_dispute_date = nil
      self.restart_dispute_time = nil
    end
  end

  def create_conversation
    self.build_conversation
    self.conversation.is_enabled = true
    self.save
  end
end
