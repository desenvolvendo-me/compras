# encoding: utf-8
class RegulatoryAct < Compras::Model
  attr_accessible :act_number, :regulatory_act_type_id, :creation_date,
                  :publication_date, :vigor_date, :budget_change_law_type,
                  :end_date, :content, :budget_law_percent, :signature_date,
                  :revenue_antecipation_percent, :authorized_debt_value,
                  :dissemination_source_ids, :classification, :parent_id,
                  :budget_change_decree_type, :origin

  attr_modal :act_number, :regulatory_act_type_id

  has_enumeration_for :budget_change_decree_type, :create_helpers => { :prefix => true }
  has_enumeration_for :budget_change_law_type
  has_enumeration_for :classification, :with => RegulatoryActClassification, create_helpers: { prefix: true }
  has_enumeration_for :origin

  belongs_to :regulatory_act_type
  belongs_to :parent, :class_name => 'RegulatoryAct'

  has_and_belongs_to_many :dissemination_sources, :join_table => :compras_dissemination_sources_compras_regulatory_acts

  has_many :children, :class_name => 'RegulatoryAct', :foreign_key => :parent_id, :dependent => :restrict
  has_many :expense_natures, :dependent => :restrict
  has_many :budget_structure_configurations, :dependent => :restrict
  has_many :budget_structure_responsibles, :dependent => :restrict
  has_many :licitation_commissions, :dependent => :restrict

  delegate :classification_law?, :to => :parent, :prefix => true, :allow_nil => true
  delegate :kind, to: :regulatory_act_type, allow_nil: true, prefix: true

  validates :regulatory_act_type, :creation_date, :publication_date, :content,
            :signature_date, :vigor_date, :act_number,
            :presence => true
  validates :budget_change_decree_type, :presence => true, if: :budget_change_decree_type_required?
  validates :budget_change_law_type, :presence => true, :if => :budget_change_law_type_required?
  validates :parent, :presence => true, :if => :classification_decree?
  validate  :validate_parent_classification

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :revenue_antecipation_percent, :numericality => { :less_than_or_equal_to => 100 }
    allowing_blank.validates :budget_law_percent, :numericality => { :less_than_or_equal_to => 100 }
    allowing_blank.validates :act_number, :content, :uniqueness => true
    allowing_blank.validates :act_number, :numericality => true
    allowing_blank.validates :vigor_date,
      :timeliness => {
        :on_or_after => :creation_date,
        :on_or_after_message => :should_be_on_or_after_creation_date,
        :type => :date
      }
    allowing_blank.validates :publication_date,
      :timeliness => {
        :on_or_after => :creation_date,
        :on_or_after_message => :should_be_on_or_after_creation_date,
        :type => :date
       }
    allowing_blank.validates :publication_date,
      :timeliness => {
        :on_or_before => :vigor_date,
        :on_or_before_message => :should_be_on_or_before_vigor_date,
        :type => :date
      }
  end

  before_save :clear_budget_change_decree_type_unless_required
  before_save :clear_origin_unless_updateable
  before_save :clear_budget_change_law_type_unless_required

  orderize :act_number
  filterize

  scope :trading_or_price_registration, lambda {
    joins { regulatory_act_type }.
    where {
      regulatory_act_type.kind.in([RegulatoryActTypeKind::PRICE_REGISTRATION,
                                  RegulatoryActTypeKind::TRADING])
    }
  }

  def to_s
    "#{regulatory_act_type} #{act_number}"
  end

  def budget_change_decree_type_required?
    classification_decree? && regulatory_act_type.to_s == 'Alteração Orçamentária'
  end

  def origin_updateable?
    budget_change_decree_type_extra_credit_decree? || budget_change_decree_type_special_credit_decree?
  end

  def budget_change_law_type_required?
    classification_law? && regulatory_act_type.to_s == 'Alteração Orçamentária'
  end

  private

  def clear_budget_change_decree_type_unless_required
    self.budget_change_decree_type = nil unless budget_change_decree_type_required?
  end

  def clear_origin_unless_updateable
    self.origin = nil unless origin_updateable?
  end

  def clear_budget_change_law_type_unless_required
    self.budget_change_law_type = nil unless budget_change_law_type_required?
  end

  def validate_parent_classification
    if classification_decree? and !parent_classification_law?
      errors.add(:parent, :parent_classification_should_be_law)
    end
  end
end
