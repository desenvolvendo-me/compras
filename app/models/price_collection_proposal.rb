class PriceCollectionProposal < ActiveRecord::Base
  attr_accessible :provider_id, :items_attributes, :email, :login

  belongs_to :price_collection
  belongs_to :provider

  has_many :items, :class_name => :PriceCollectionProposalItem, :dependent => :destroy, :order => :id

  delegate :date, :full_period, :to => :price_collection, :allow_nil => true, :prefix => true
  delegate :price_collection_lots, :to => :price_collection, :allow_nil => true
  delegate :name, :email, :email=, :login, :login=, :to => :provider, :allow_nil => true

  accepts_nested_attributes_for :items, :allow_destroy => true

  validates :provider, :presence => true
  validates :email, :login, :presence => true, :if => :new_record?

  orderize :id
  filterize

  def to_s
    "#{price_collection} - #{provider}"
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

  def editable_by? user
    provider == user.authenticable
  end

  def self.by_price_collection_and_provider(params = {})
    where { price_collection_id.eq(params.fetch(:price_collection_id)) &
            provider_id.eq(params.fetch(:provider_id)) }
  end
end
