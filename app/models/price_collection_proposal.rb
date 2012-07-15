class PriceCollectionProposal < Compras::Model
  attr_accessible :creditor_id, :items_attributes, :status, :user_attributes

  belongs_to :price_collection
  belongs_to :creditor

  has_many :items, :class_name => 'PriceCollectionProposalItem', :dependent => :destroy, :order => :id
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
    update_attribute :status, PriceCollectionStatus::ANNULLED
  end

  def self.by_price_collection_and_creditor(params = {})
    where { price_collection_id.eq(params.fetch(:price_collection_id)) &
            creditor_id.eq(params.fetch(:creditor_id)) }
  end

  def self.by_price_collection_id_sum_items(price_collection)
    joins { items.price_collection_lot_item }.
    select { creditor_id }.
    select { sum(items.unit_price * items.price_collection_lot_item.quantity).as(total_value) }.
    where { status.not_eq(PriceCollectionStatus::ANNULLED) & price_collection_id.eq(price_collection) }.
    group { creditor_id }.
    order { 'total_value' }
  end

  protected

  def must_have_a_valid_creditor_user
    return if !user || user.valid?

    errors[:user_attributes] << user.errors.full_messages
  end
end
