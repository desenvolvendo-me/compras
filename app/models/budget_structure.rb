class BudgetStructure < Compras::Model
  attr_accessible :description, :code, :tce_code, :acronym
  attr_accessible :performance_field, :budget_structure_configuration_id
  attr_accessible :administration_type_id, :address_attributes
  attr_accessible :budget_structure_responsibles_attributes, :kind
  attr_accessible :budget_structure_level_id, :parent_id

  attr_modal :parent, :budget_structure_level_id, :description

  has_enumeration_for :kind, :with => BudgetStructureKind,
    :create_helpers => true, :create_scopes => true

  belongs_to :budget_structure_configuration
  belongs_to :administration_type
  belongs_to :budget_structure_level
  belongs_to :parent, :class_name => 'BudgetStructure'

  has_one :address, :as => :addressable, :dependent => :destroy

  has_many :budget_allocations, :dependent => :restrict
  has_many :purchase_solicitations, :dependent => :restrict
  has_many :budget_structure_responsibles, :dependent => :destroy, :order => :id
  has_many :direct_purchases, :dependent => :restrict
  has_many :children, :class_name => 'BudgetStructure', :foreign_key => :parent_id, :dependent => :restrict

  delegate :digits, :level, :separator, :upper_budget_structure_level, :to => :budget_structure_level, :allow_nil => true

  validates :description, :code, :tce_code, :acronym, :presence => true
  validates :performance_field, :budget_structure_configuration, :presence => true
  validates :administration_type, :kind, :presence => true
  validates :budget_structure_level, :presence => true
  validates :parent, :presence => true, :if => :level_greater_than_1?
  validates :budget_structure_responsibles, :no_duplication => :responsible_id
  validate :parent_level_must_be_immediate_superior

  accepts_nested_attributes_for :address
  accepts_nested_attributes_for :budget_structure_responsibles, :allow_destroy => true

  orderize :description
  filterize

  scope :search_by_code_and_configuration_and_level, lambda { |code, configuration_id, level|
    joins{ budget_structure_configuration }.
    joins{ budget_structure_level }.
    where{ |structure|
      structure.code.eq(code) &
      structure.budget_structure_level.level.eq(level) &
      structure.budget_structure_configuration.id.eq(configuration_id)
    }
  }

  before_create :cannot_have_duplicated_code_in_same_configuration_and_level

  def parent_budget_structure_level_id
    upper_budget_structure_level.id if parent
  end

  def persisted_budget_structure_responsibles
    budget_structure_responsibles.select(&:persisted?)
  end

  def budget_structure_responsibles_changed?
    persisted_budget_structure_responsibles.size != budget_structure_responsibles.size
  end

  def to_s
    "#{budget_structure} - #{description}"
  end

  protected

  def budget_structure
    return '' unless code
    parent_budget_structure(parent) + code.to_s
  end

  def cannot_have_duplicated_responsibles
    single_responsibles = []

    budget_structure_responsibles.each do |budget_structure_responsible|
      if single_responsibles.include?(budget_structure_responsible.responsible_id)
        errors.add(:budget_structure_responsibles)
        budget_structure_responsible.errors.add(:responsible_id, :taken)
      end
      single_responsibles << budget_structure_responsible.responsible_id
    end
  end

  def parent_level_must_be_immediate_superior
    return unless parent

    if parent.level.succ != level
      errors.add(:base, :invalid)
      errors.add(:parent, :cannot_have_a_parent_who_is_not_immediate_superior, :level => level.pred)
    end
  end

  def cannot_have_duplicated_code_in_same_configuration_and_level
    if any_code_in_same_configuration_and_level?
      errors.add(:base, :invalid)
      errors.add(:code, :cannot_have_a_code_with_configuration_and_level_repeated)
    end
  end

  def any_code_in_same_configuration_and_level?
    BudgetStructure.search_by_code_and_configuration_and_level(code, budget_structure_configuration_id, level).any?
  end

  def level_greater_than_1?
    level && level != 1
  end

  def parent_budget_structure(parent, budget_structure='')
    return '' if parent.nil?
    budget_structure += parent.code.to_s + parent.separator
    parent_budget_structure(parent.parent) + budget_structure
  end
end
