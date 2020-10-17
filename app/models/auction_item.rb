class AuctionItem < Compras::Model
  attr_accessible :material_id, :reference_unit_id, :description, :lot, :quantity,
                  :detailed_description, :estimated_value, :max_value , :benefit_type, :auction_id

  belongs_to :auction
  belongs_to :material

  has_one :reference_unit, through: :material
  has_one :material_class, through: :material
  has_many :disput_items, class_name: 'AuctionDisputItem', :dependent => :destroy

  has_enumeration_for :benefit_type, :with => BenefitType

  after_create :create_disput_item

  orderize :id
  filterize

  scope :by_lot, lambda{
    select('COUNT(*) as quantity, lot').group(:lot)
  }

  def to_s
    material
  end

  private

  def create_disput_item
    disput_item = AuctionDisputItem.new
    disput_item.auction_item = self
    disput_item.auction      = self.auction
    disput_item.status       = AuctionDisputItemStatus::CLOSED
    disput_item.save
  end
end
