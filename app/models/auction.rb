class Auction < Compras::Model
  attr_accessible :auction_type,:licitation_number,:process_number,:year,:dispute_type,
                  :judment_form,:covid_law,:purchase_value,:items_quantity, :group_items_attributes,
                  :object,:object_management,:employee_id, :items_attributes, :sensitive_value, :variation_type, :minimum_interval,
                  :decree_treatment, :document_edict, :disclosure_date, :responsible_dissemination_id, :notice_availability,
                  :proposal_delivery, :bid_opening, :internet_address, :city, :neighborhood, :street, :telephone, :cell_phone

  attr_modal :process_number, :proposal_delivery, :bid_opening


  belongs_to :employee
  belongs_to :responsible_dissemination, class_name: "Employee"
  has_many :items, class_name: 'AuctionItem'
  has_many :group_items, class_name: 'AuctionGroupItem'
  has_many :creditor_proposals, class_name: 'AuctionCreditorProposal'

  mount_uploader :document_edict, UnicoUploader

  has_enumeration_for :auction_type, :with => AuctionType
  has_enumeration_for :dispute_type, :with => AuctionDisputeType
  has_enumeration_for :judment_form, :with => AuctionJudmentForm
  has_enumeration_for :variation_type, :with => AuctionVariationType

  accepts_nested_attributes_for :items, :allow_destroy => true
  accepts_nested_attributes_for :group_items, :allow_destroy => true

  validates :year, :mask => "9999", presence: true
  validates :licitation_number, presence: true

  orderize :id
  filterize
end
