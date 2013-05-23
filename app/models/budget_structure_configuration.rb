class BudgetStructureConfiguration < Accounting::Model
  attr_modal :description, :entity_id, :regulatory_act_id

  belongs_to :regulatory_act
  belongs_to :entity

  has_many :budget_structure_levels, :order => 'level asc', :dependent => :destroy, :order => :id
  has_many :budget_structures, :dependent => :restrict

  orderize :description

  def self.filter(params)
    query = scoped
    query = query.where { entity_id.eq(params[:entity_id]) } if params[:entity_id].present?
    query = query.where { description.eq(params[:description]) } if params[:description].present?
    query = query.where { regulatory_act_id.eq(params[:regulatory_act_id]) } if params[:regulatory_act_id].present?
    query = query.where { year.eq(params[:year]) } if params[:year].present?

    query
  end

  scope :by_year, lambda { |year| where(year: year) if year.present? }

  def to_s
    description
  end

  def ordered_budget_structure_levels
    return budget_structure_levels if any_not_persisted_level?

    budget_structure_levels.sort_by(&:level)
  end

  def mask(mask_generator = MaskConfigurationParser)
    mask_generator.from_levels(ordered_budget_structure_levels)
  end

  protected

  def any_not_persisted_level?
    budget_structure_levels.select(&:new_record?).present?
  end

  def separator_for_budget_structure_levels
    ordered_budget_structure_levels.each_with_index do |budget_structure_level, idx|
      if budget_structure_level.separator.blank? && idx.succ < budget_structure_levels.size
        budget_structure_level.errors.add(:separator, :blank)
      end
    end
  end
end
