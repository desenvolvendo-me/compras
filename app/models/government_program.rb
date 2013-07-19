class GovernmentProgram < Accounting::Model
  attr_readonly :entity_id

  attr_accessor :budget_structure, :target_audience

  attr_modal :code, :program_kind_id, :title, :macro_objective_id

  belongs_to :program_kind
  belongs_to :macro_objective
  belongs_to :responsible, :class_name => "BudgetStructure", :foreign_key => "budget_structure_id"
  belongs_to :person

  has_and_belongs_to_many :budget_structures, :join_table => :accounting_budget_structures_government_programs
  has_and_belongs_to_many :target_audiences, :join_table => :accounting_government_programs_target_audiences

  orderize :description

  scope :by_entity_id, lambda { |entity_id| where(entity_id: entity_id) if entity_id.present? }
  scope :by_year, lambda { |year| where(year: year) if year.present? }

  def self.filter(params)
    query = scoped
    query = query.where { code.eq(params[:code]) } if params[:code].present?
    query = query.where { title.eq(params[:title]) } if params[:title].present?
    query = query.where { program_kind_id.eq(params[:program_kind_id]) } if params[:program_kind_id].present?
    query = query.where { macro_objective_id.eq(params[:macro_objective_id]) } if params[:macro_objective_id].present?
    query = query.where { year.eq(params[:year]) } if params[:year].present?

    query
  end

  def to_s
    "#{code} - #{title}"
  end

  private

  def date_order
    return unless start_date && end_date

    if start_date >= end_date
      errors.add(:end_date, :must_be_greater_than_start_date)
    end
  end
end
