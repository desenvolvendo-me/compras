class PriceCollection < ActiveRecord::Base
  attr_accessible :collection_number, :year, :date, :delivery_location_id, :employee_id, :payment_method_id
  attr_accessible :period_id, :object_description, :observations, :proposal_validity_id, :expiration
  attr_accessible :price_collection_lots_attributes, :provider_ids

  attr_readonly :year, :collection_number

  has_enumeration_for :status

  belongs_to :delivery_location
  belongs_to :employee
  belongs_to :payment_method
  belongs_to :period
  belongs_to :proposal_validity, :class_name => 'Period', :foreign_key => 'proposal_validity_id'

  has_many :price_collection_lots, :dependent => :destroy, :order => :id

  has_many :price_collections_providers, :dependent => :destroy, :order => :id
  has_many :providers, :through => :price_collections_providers

  accepts_nested_attributes_for :price_collection_lots, :allow_destroy => true

  validates :collection_number, :year, :date, :delivery_location, :employee, :presence => true
  validates :payment_method, :period, :object_description, :expiration, :proposal_validity, :presence => true
  validates :year, :mask => "9999"
  validates :date, :expiration, :timeliness => { :on_or_after => :today, :type => :date }, :on => :create

  orderize :id
  filterize

  def to_s
    "#{collection_number}/#{year}"
  end

  def next_collection_number
    return 1 unless last_by_self_year

    last_by_self_year.collection_number.succ
  end

  def last_by_self_year
    self.class.where{ |p| p.year.eq(year) }.order{ id }.last
  end
end
