class PriceCollection < ActiveRecord::Base
  attr_accessible :collection_number, :year, :date, :delivery_location_id, :employee_id, :payment_method_id
  attr_accessible :object_description, :observations, :expiration
  attr_accessible :period, :period_unit, :proposal_validity, :proposal_validity_unit
  attr_accessible :price_collection_lots_attributes, :provider_ids, :type_of_calculation

  attr_readonly :year, :collection_number

  has_enumeration_for :status
  has_enumeration_for :period_unit, :with => PeriodUnit
  has_enumeration_for :proposal_validity_unit, :with => PeriodUnit
  has_enumeration_for :type_of_calculation, :with => PriceCollectionTypeOfCalculation

  belongs_to :delivery_location
  belongs_to :employee
  belongs_to :payment_method

  has_many :price_collection_lots, :dependent => :destroy, :order => :id
  has_many :items, :through => :price_collection_lots
  has_many :price_collection_proposals, :dependent => :destroy, :order => :id

  has_many :price_collections_providers, :dependent => :destroy, :order => :id
  has_many :providers, :through => :price_collections_providers

  delegate :provider, :total_price, :to => :winner_proposal, :allow_nil => true, :prefix => true

  accepts_nested_attributes_for :price_collection_lots, :allow_destroy => true

  validates :collection_number, :year, :date, :delivery_location, :employee, :presence => true
  validates :payment_method, :object_description, :expiration, :presence => true
  validates :period, :period_unit, :proposal_validity, :proposal_validity_unit, :presence => true
  validates :year, :mask => "9999"
  validates :date, :expiration, :timeliness => { :on_or_after => :today, :type => :date }, :on => :create

  after_save :generate_proposals

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

  def winner_proposal
    price_collection_proposals.min_by(&:total_price)
  end

  protected

  def generate_proposals
    PriceCollectionProposalGenerator.new(self).generate!
  end
end
