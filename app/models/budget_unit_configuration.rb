class BudgetUnitConfiguration < ActiveRecord::Base
  attr_accessible :description, :entity_id, :regulatory_act_id
  attr_accessible :budget_unit_levels, :budget_unit_levels_attributes

  attr_modal :description, :entity_id, :regulatory_act_id

  belongs_to :regulatory_act
  belongs_to :entity

  has_many :budget_unit_levels, :order => 'level asc', :dependent => :destroy, :order => :id
  has_many :budget_units, :dependent => :restrict

  accepts_nested_attributes_for :budget_unit_levels, :allow_destroy => true

  validates :description, :entity, :regulatory_act, :presence => true
  validate :organogram_separator_for_budget_unit_levels

  orderize :description
  filterize

  def to_s
    description
  end

  def ordered_budget_unit_levels
    budget_unit_levels.sort { |x, y| x.level <=> y.level }
  end

  def mask
    m = ''
    ordered_budget_unit_levels.each_with_index do |budget_unit_level, idx|
      m += '9' * budget_unit_level.digits
      m += budget_unit_level.organogram_separator unless budget_unit_level.blank? or (idx+1) == budget_unit_levels.size
    end
    m
  end

  def as_json(options = {})
    super.merge(:mask => mask)
  end

  protected

  def organogram_separator_for_budget_unit_levels
    ordered_budget_unit_levels.each_with_index do |budget_unit_level, idx|
      if budget_unit_level.organogram_separator.blank? and (idx+1) < budget_unit_levels.size
        budget_unit_level.errors.add(:organogram_separator, :blank)
      end
    end
  end
end
