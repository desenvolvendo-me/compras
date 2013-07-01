class BudgetStructure < Accounting::Model
  attr_modal :full_code, :description, :budget_structure_level_id, :kind

  belongs_to :budget_structure_configuration
  belongs_to :administration_type
  belongs_to :budget_structure_level
  belongs_to :parent, :class_name => 'BudgetStructure'

  has_one :address, :as => :addressable, :dependent => :destroy

  has_many :entity, :dependent => :restrict
  has_many :signatures, :dependent => :restrict
  has_many :budget_allocations, :dependent => :restrict
  has_many :budget_structure_responsibles, :dependent => :destroy, :order => :id
  has_many :children, :class_name => 'BudgetStructure', :foreign_key => :parent_id, :dependent => :restrict

  delegate :digits, :level, :separator, :to => :budget_structure_level, :allow_nil => true
  delegate :mask, :to => :budget_structure_level, :prefix => true,
           :allow_nil => true

  delegate :street, :street_id, :number, :complement, :zip_code,
           :to => :address, :prefix => true, :allow_nil => true

  delegate :neighborhood, :neighborhood_id, :city, :state,
           :to => :address, :prefix => true, :allow_nil => true

  scope :by_year, lambda { |year|
    joins { budget_structure_configuration }.
    where { |budget_structure| budget_structure.budget_structure_configuration.year.eq(year) }
  }

  scope :ordered, joins { parent.outer }.
                  order { parent.code }.
                  order { code }

  filterize

  def to_s
    "#{full_code || budget_structure} - #{description}"
  end

  def structure_sequence
    return [self] if parent.nil?

    parent.structure_sequence << self
  end

  protected

  def budget_structure
    return '' unless code
    parent_budget_structure(parent) + code.to_s
  end

  def parent_budget_structure(parent, budget_structure='')
    return '' if parent.nil?
    budget_structure += parent.code.to_s + parent.separator
    parent_budget_structure(parent.parent) + budget_structure
  end
end
