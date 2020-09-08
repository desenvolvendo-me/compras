class Auction < Compras::Model
  attr_accessible :auction_type, :licitation_number, :process_number, :year, :dispute_type, :zip_code,
                  :judment_form, :covid_law, :purchase_value, :items_quantity, :group_items_attributes,
                  :object, :object_management, :employee_id, :items_attributes, :sensitive_value, :variation_type, :minimum_interval,
                  :decree_treatment, :document_edict, :disclosure_date, :responsible_dissemination_id, :notice_availability,
                  :proposal_delivery, :bid_opening, :internet_address, :city,
                  :neighborhood, :street, :telephone, :cell_phone, :user_id, :bid_opening_time

  attr_modal :process_number, :proposal_delivery, :bid_opening

  belongs_to :employee
  belongs_to :user
  belongs_to :responsible_dissemination, class_name: "Employee"
  has_many :items, class_name: "AuctionItem"
  has_many :group_items, class_name: "AuctionGroupItem"
  has_many :creditor_proposals, class_name: "AuctionCreditorProposal"
  has_many :auction_support_teams
  has_many :bids, class_name: 'AuctionBid'

  mount_uploader :document_edict, UnicoUploader

  has_enumeration_for :auction_type, :with => AuctionType
  has_enumeration_for :dispute_type, :with => AuctionDisputeType
  has_enumeration_for :judment_form, :with => AuctionJudmentForm


  accepts_nested_attributes_for :items, :allow_destroy => true
  accepts_nested_attributes_for :group_items, :allow_destroy => true
  accepts_nested_attributes_for :auction_support_teams, :allow_destroy => true

  validates :year, :mask => "9999", presence: true
  validates :licitation_number, presence: true
  validates :zip_code, mask: "99999-999", allow_blank: true
  validates :cell_phone, mask: "(99) 99999-9999", :allow_blank => true
  validates :telephone, mask: "(99) 9999-9999", :allow_blank => true

  orderize :id
  filterize
end
