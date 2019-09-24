class PriceCollection < Compras::Model
  attr_accessible :code, :year, :date, :delivery_location_id, :employee_id,
                  :payment_method_id, :object_description, :observations,
                  :expiration, :period, :period_unit, :proposal_validity,
                  :proposal_validity_unit, :creditor_ids, :type_of_calculation,
                  :purchase_solicitation_ids, :price_collection_proposals_attributes,
                  :items_attributes

  attr_readonly :year, :code

  attr_modal :code, :year, :date, :delivery_location_id, :employee_id,
             :payment_method_id, :object_description, :observations, :expiration,
             :period, :period_unit, :proposal_validity, :proposal_validity_unit,
             :type_of_calculation, :status

  auto_increment :code, :by => :year

  has_enumeration_for :period_unit, :with => PeriodUnit
  has_enumeration_for :proposal_validity_unit, :with => PeriodUnit
  has_enumeration_for :status, :with => PriceCollectionStatus, :create_helpers => true
  has_enumeration_for :type_of_calculation, :with => PriceCollectionTypeOfCalculation, create_helpers: true

  belongs_to :delivery_location
  belongs_to :employee
  belongs_to :payment_method

  has_many :creditors, :through => :price_collection_proposals
  has_many :items, class_name: 'PriceCollectionItem', :order => :id
  has_many :price_collection_classifications, :as => :classifiable, :dependent => :destroy
  has_many :price_collection_proposals, :dependent => :destroy, :order => :id

  has_one  :annul, :class_name => 'PriceCollectionAnnul'

  has_and_belongs_to_many :purchase_solicitations, join_table: :compras_price_collections_purchase_solicitations

  delegate :creditor, :total_price, :to => :winner_proposal, :allow_nil => true, :prefix => true
  delegate :lots, :to => :items, :allow_nil => true

  accepts_nested_attributes_for :items, :allow_destroy => true
  accepts_nested_attributes_for :price_collection_proposals, :allow_destroy => true

  # validate :validate_quantity_of_creditors
  # validate :must_have_at_least_one_item
  #
  # validates :items, :no_duplication => :material_id
  # validates :year, :date, :delivery_location, :employee, :presence => true
  # validates :payment_method, :object_description, :expiration, :presence => true
  # validates :period, :period_unit, :proposal_validity, :proposal_validity_unit, :presence => true
  # validates :type_of_calculation, :presence => true
  # validates :year, :mask => "9999"
  # validates :date, :expiration,
  #   :timeliness => {
  #     :on_or_after => :today,
  #     :on_or_after_message => :should_be_on_or_after_today,
  #     :type => :date
  #   }, :on => :create

  after_save :generate_proposal_items

  orderize "id DESC"
  filterize

  def to_s
    "#{code}/#{year}"
  end

  def all_price_collection_classifications
    price_collection_proposals.classifications
  end

  def annul!
    update_column :status, PriceCollectionStatus::ANNULLED
  end

  def destroy_all_price_collection_classifications
    price_collection_proposals.destroy_all_classifications
  end

  def full_period
    "#{period} #{period_unit_humanize}"
  end

  def winner_proposal
    price_collection_proposals.min_by(&:total_price)
  end

  protected

  def proposals_count
    self.price_collection_proposals.reject(&:marked_for_destruction?).count
  end

  def validate_quantity_of_creditors
    unless proposals_count >= 3
      errors.add(:base, :must_have_at_least_three_creditors)
    end
  end

  def generate_proposal_items
    PriceCollectionProposalUpdater.new(self).update!
  end

  def must_have_at_least_one_item
    if items.reject(&:marked_for_destruction?).empty?
      errors.add(:items, :must_have_at_least_one_item)
    end
  end

end
