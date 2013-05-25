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

  delegate :digits, :level, :separator, :upper_budget_structure_level, :to => :budget_structure_level, :allow_nil => true
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

  scope :by_structure_sequence_ids, lambda { |ids|
    where { id.in(ids) }
  }

  scope :ordered, joins { parent.outer }.
                  order { parent.code }.
                  order { code }

  filterize

  def self.order_by_level
    joins { budget_structure_level }.
    order { budget_structure_level.level }
  end

  def parent_budget_structure_level_id
    upper_budget_structure_level.id if parent
  end

  def budget_structure_responsibles_new_records_first
    budget_structure_responsibles.sort { |x, y|
      x.new_record? ? 0 : 1
    }
  end

  def persisted_budget_structure_responsibles_without_end_date
    persisted_budget_structure_responsibles.select do |responsible|
      responsible.end_date.blank?
    end
  end

  def persisted_budget_structure_responsibles
    budget_structure_responsibles.select(&:persisted?)
  end

  def budget_structure_responsibles_changed?
    persisted_budget_structure_responsibles.size != budget_structure_responsibles.size
  end

  def to_s
    "#{full_code || budget_structure} - #{description}"
  end

  def structure_sequence
    return [self] if parent.nil?

    parent.structure_sequence << self
  end

  def child_structure_sequence
    return [self] if children.empty?

    children.flat_map(&:child_structure_sequence) + [self]
  end

  protected

  def budget_structure
    return '' unless code
    parent_budget_structure(parent) + code.to_s
  end

  def set_full_code_with_budget_structure
    write_attribute :full_code, budget_structure
  end

  def parent_level_must_be_immediate_superior
    return unless parent

    if parent.level.succ != level
      errors.add(:base, :invalid)
      errors.add(:parent, :cannot_have_a_parent_who_is_not_immediate_superior, :level => level.pred)
    end
  end

  def cannot_have_the_same_code_and_configuration_and_level
    if duplicated_code?
      errors.add(:code, :cannot_have_the_same_code_and_configuration_and_level)
    end
  end

  def duplicated_code?
    BudgetStructure.
      where{ |structure|
        structure.id.not_eq(id) &
        structure.code.eq(code) &
        structure.budget_structure_level_id.eq(budget_structure_level_id) &
        structure.budget_structure_configuration_id.eq(budget_structure_configuration_id) &
        structure.parent_id.eq(parent_id)
      }.any?
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
