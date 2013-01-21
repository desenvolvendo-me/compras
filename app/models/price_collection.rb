class PriceCollection < Compras::Model
  attr_accessible :code, :year, :date, :delivery_location_id, :employee_id, :payment_method_id
  attr_accessible :object_description, :observations, :expiration
  attr_accessible :period, :period_unit, :proposal_validity, :proposal_validity_unit
  attr_accessible :price_collection_lots_attributes, :creditor_ids, :type_of_calculation
  attr_accessible :price_collection_proposals_attributes

  attr_readonly :year, :code

  attr_modal :code, :year, :date, :delivery_location_id, :employee_id,
             :payment_method_id, :object_description, :observations, :expiration,
             :period, :period_unit, :proposal_validity, :proposal_validity_unit,
             :type_of_calculation, :status

  auto_increment :code, :by => :year

  has_enumeration_for :status, :with => PriceCollectionStatus, :create_helpers => true
  has_enumeration_for :period_unit, :with => PeriodUnit
  has_enumeration_for :proposal_validity_unit, :with => PeriodUnit
  has_enumeration_for :type_of_calculation, :with => PriceCollectionTypeOfCalculation

  belongs_to :delivery_location
  belongs_to :employee
  belongs_to :payment_method

  has_one :annul, :class_name => 'PriceCollectionAnnul'
  has_many :price_collection_lots, :dependent => :destroy, :order => :id
  has_many :items, :through => :price_collection_lots, :order => :id
  has_many :price_collection_proposals, :dependent => :destroy, :order => :id
  has_many :creditors, :through => :price_collection_proposals
  has_many :price_collection_classifications, :as => :classifiable, :dependent => :destroy

  delegate :creditor, :total_price, :to => :winner_proposal, :allow_nil => true, :prefix => true

  accepts_nested_attributes_for :price_collection_lots, :allow_destroy => true
  accepts_nested_attributes_for :price_collection_proposals, :allow_destroy => true

  validates :year, :date, :delivery_location, :employee, :presence => true
  validates :payment_method, :object_description, :expiration, :presence => true
  validates :period, :period_unit, :proposal_validity, :proposal_validity_unit, :presence => true
  validates :type_of_calculation, :presence => true
  validates :year, :mask => "9999"
  validates :date, :expiration,
    :timeliness => {
      :on_or_after => :today,
      :on_or_after_message => :should_be_on_or_after_today,
      :type => :date
    }, :on => :create

  after_save :generate_proposal_items

  orderize :id
  filterize

  def to_s
    code_and_year
  end

  def code_and_year
    "#{code}/#{year}"
  end

  def winner_proposal
    price_collection_proposals.min_by(&:total_price)
  end

  def full_period
    "#{period} #{period_unit_humanize}"
  end

  def annul!
    update_column :status, PriceCollectionStatus::ANNULLED
  end

  def all_price_collection_classifications
    price_collection_proposals.classifications
  end

  def destroy_all_price_collection_classifications
    price_collection_proposals.destroy_all_classifications
  end

  def price_collection_lots_with_items
    price_collection_lots.select {|l| l unless l.items.empty? }
  end

  protected

  def generate_proposal_items
    PriceCollectionProposalUpdater.new(self).update!
  end
end
