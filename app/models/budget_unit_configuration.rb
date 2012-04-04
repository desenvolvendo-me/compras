class BudgetUnitConfiguration < ActiveRecord::Base
  attr_accessible :description, :entity_id, :regulatory_act_id
  attr_accessible :organogram_levels, :organogram_levels_attributes

  attr_modal :description, :entity_id, :regulatory_act_id

  belongs_to :regulatory_act
  belongs_to :entity

  has_many :organogram_levels, :order => 'level asc', :dependent => :destroy, :order => :id
  has_many :budget_units, :dependent => :restrict

  accepts_nested_attributes_for :organogram_levels, :allow_destroy => true

  validates :description, :entity, :regulatory_act, :presence => true
  validate :organogram_separator_for_organogram_levels

  orderize :description
  filterize

  def to_s
    description
  end

  def ordered_organogram_levels
    organogram_levels.sort { |x, y| x.level <=> y.level }
  end

  def mask
    m = ''
    ordered_organogram_levels.each_with_index do |organogram_level, idx|
      m += '9' * organogram_level.digits
      m += organogram_level.organogram_separator unless organogram_level.blank? or (idx+1) == organogram_levels.size
    end
    m
  end

  def as_json(options = {})
    super.merge(:mask => mask)
  end

  protected

  def organogram_separator_for_organogram_levels
    ordered_organogram_levels.each_with_index do |organogram_level, idx|
      if organogram_level.organogram_separator.blank? and (idx+1) < organogram_levels.size
        organogram_level.errors.add(:organogram_separator, :blank)
      end
    end
  end
end
