class PriceCollectionProposal < Compras::Model
  attr_accessible :creditor_id, :items_attributes, :status, :user_attributes

  belongs_to :price_collection
  belongs_to :creditor

  has_many :items, :class_name => 'PriceCollectionProposalItem', :dependent => :destroy, :order => :unit_price
  has_one :annul, :class_name => 'ResourceAnnul', :as => :annullable, :dependent => :destroy

  has_enumeration_for :status, :with => PriceCollectionStatus, :create_helpers => true

  delegate :date, :full_period, :to => :price_collection, :allow_nil => true, :prefix => true
  delegate :price_collection_lots, :to => :price_collection, :allow_nil => true
  delegate :name, :email, :login, :user_attributes, :user_attributes=, :user, :to => :creditor, :allow_nil => true

  accepts_nested_attributes_for :items, :allow_destroy => true

  validates :creditor, :presence => true
  validate :must_have_a_valid_creditor_user

  orderize :id
  filterize

  def build_user
    return user if user.present?

    creditor.try(:build_user)
  end

  def to_s
    "#{price_collection} - #{creditor}"
  end

  def total_price
    return 0 if items.empty?

    items.sum(&:total_price)
  end

  def global_classification
    proposals = price_collection.price_collection_proposals.sort_by &:total_price
    proposals.index(self).succ
  end

  def classification_by_lot(lot)
    items_with_creditor = PriceCollectionProposalItem.by_lot_item_order_by_unit_price(lot.id)

    items_with_creditor.index { |item| item.creditor_id.to_i == creditor_id.to_i }.succ
  end

  def classification_by_item(proposal_item)
    proposal_items = PriceCollectionProposalItem.by_item_order_by_unit_price(proposal_item.price_collection_lot_item)
    proposal_items.index(proposal_item).succ
  end

  def items_by_lot(lot)
    items.select { |item| item.price_collection_lot == lot }
  end

  def item_total_value_by_lot(lot = nil)
    return 0 unless lot

    items_by_lot(lot).sum(&:total_price)
  end

  def editable_by?(user)
    creditor == user.authenticable
  end

  def annul!
    update_column :status, PriceCollectionStatus::ANNULLED
  end

  protected

  def must_have_a_valid_creditor_user
    return if !user || user.valid?

    errors[:user_attributes] << user.errors.full_messages
  end
end
