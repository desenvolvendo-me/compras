class PriceCollectionProposal < Compras::Model
  attr_accessible :creditor_id, :items_attributes, :status, :user_attributes

  belongs_to :price_collection
  belongs_to :creditor
  belongs_to :employee

  has_many :items, class_name: 'PriceCollectionProposalItem', :dependent => :destroy, :order => :unit_price
  has_many :price_collection_classifications, :dependent => :destroy, :order => :id
  has_one :annul, :class_name => 'ResourceAnnul', :as => :annullable, :dependent => :destroy

  has_enumeration_for :status, :with => PriceCollectionStatus, :create_helpers => true

  delegate :date, :full_period, :code, :year, :lots, :to => :price_collection, :allow_nil => true, :prefix => true
  delegate :name, :email, :login, :user_attributes, :user_attributes=, :user, :to => :creditor, :allow_nil => true

  accepts_nested_attributes_for :items, :allow_destroy => true

  validates :creditor, :presence => true
  validate :must_have_a_valid_creditor_user, if: :user

  orderize "id DESC"
  filterize

  def self.destroy_all_classifications
    classifications.destroy_all
  end

  def self.classifications
    PriceCollectionClassification.where do |classification|
      classification.price_collection_proposal_id.in(pluck(:id))
    end
  end

  def build_user
    return user if user.present?

    creditor.try(:build_user)
  end

  def to_s
    "#{price_collection} - #{creditor}"
  end

  def total_price
    return BigDecimal(0) if items.empty?

    items.sum(&:total_price)
  end

  def global_classification
    proposals = price_collection.price_collection_proposals.sort_by(&:total_price)

    classification = proposals.index(self).succ
    classification = -1 if has_item_with_unit_price_equals_zero
    classification
  end

  def classification_by_lot(lot)
    items_with_creditor = PriceCollectionProposalItem.by_lot_item_order_by_unit_price(lot).reload

    return unless items_with_creditor.any?

    classification = items_with_creditor.index { |item| item.creditor_id.to_i == creditor_id.to_i }.succ
    classification = -1 if has_item_with_unit_price_equals_zero(lot)
    classification
  end

  def classification_by_item(proposal_item)
    proposal_items = PriceCollectionProposalItem.by_item_order_by_unit_price(proposal_item.price_collection_item)

    classification = proposal_items.index(proposal_item).succ
    classification = -1 if proposal_item.unit_price <= 0
    classification
  end

  def has_item_with_unit_price_equals_zero(lot = nil)
    items.any_without_unit_price?(lot)
  end

  def items_by_lot(lot)
    items.select { |item| item.price_collection_item.lot == lot }
  end

  def item_total_value_by_lot(lot = nil)
    return BigDecimal(0) unless lot

    items_by_lot(lot).sum(&:total_price)
  end

  def editable_by?(user)
    creditor == user.authenticable || user.authenticable.is_a?(Employee)
  end

  def annul!
    update_column :status, PriceCollectionStatus::ANNULLED
  end

  protected

  def must_have_a_valid_creditor_user
    return if (user.valid? && user.confirmed?) || !user.confirmed?

    errors.add(:base, user.errors.full_messages)
  end
end
