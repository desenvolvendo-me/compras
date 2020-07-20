class Auction < Compras::Model
  attr_accessible :auction_type,:licitation_number,:process_number,:year,:dispute_type,
                  :judment_form,:covid_law,:purchase_value,:items_quantity, :group_items_attributes,
                  :object,:object_management,:employee_id, :items_attributes

  belongs_to :employee

  has_many :items, class_name: 'AuctionItem'
  has_many :group_items, class_name: 'AuctionGroupItem'

  has_enumeration_for :auction_type, :with => AuctionType
  has_enumeration_for :dispute_type, :with => AuctionDisputeType
  has_enumeration_for :judment_form, :with => AuctionJudmentForm

  accepts_nested_attributes_for :items, :allow_destroy => true
  accepts_nested_attributes_for :group_items, :allow_destroy => true

  validates :year, :mask => "9999", presence: true
  validates :licitation_number, presence: true

  orderize :id
  filterize
end
