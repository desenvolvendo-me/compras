class BudgetStructureConfiguration < Compras::Model
  attr_accessible :description, :entity_id, :regulatory_act_id
  attr_accessible :budget_structure_levels, :budget_structure_levels_attributes

  attr_modal :description, :entity_id, :regulatory_act_id

  belongs_to :regulatory_act
  belongs_to :entity

  has_many :budget_structure_levels, :order => 'level asc', :dependent => :destroy, :order => :id
  has_many :budget_structures, :dependent => :restrict

  accepts_nested_attributes_for :budget_structure_levels, :allow_destroy => true

  validates :description, :entity, :regulatory_act, :presence => true
  validate :separator_for_budget_structure_levels

  orderize :description
  filterize

  def to_s
    description
  end

  def ordered_budget_structure_levels
    budget_structure_levels.sort { |x, y| x.level <=> y.level }
  end

  def mask
    final_mask = ''

    ordered_budget_structure_levels.each_with_index do |budget_structure_level, index|
      next unless budget_structure_level.digits?

      final_mask += '9' * budget_structure_level.digits
      final_mask += budget_structure_level.separator unless budget_structure_level.separator.blank? || (index + 1) == budget_structure_levels.size
    end

    final_mask
  end

  protected

  def separator_for_budget_structure_levels
    ordered_budget_structure_levels.each_with_index do |budget_structure_level, idx|
      if budget_structure_level.separator.blank? && idx.succ < budget_structure_levels.size
        budget_structure_level.errors.add(:separator, :blank)
      end
    end
  end
end
