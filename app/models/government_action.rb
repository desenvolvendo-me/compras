class GovernmentAction < Accounting::Model
  attr_readonly :entity_id

  attr_modal :code, :title, :description, :action_type, :budget_type

  belongs_to :entity
  belongs_to :product
  belongs_to :reference_unit

  has_many :budget_allocations, :dependent => :restrict

  orderize :code

  def self.filter(params)
    query = scoped
    query = query.where { code.eq(params[:code]) } if params[:code].present?
    query = query.where { title.eq(params[:title]) } if params[:title].present?
    query = query.where { description.eq(params[:description]) } if params[:description].present?
    query = query.where { action_type.eq(params[:action_type]) } if params[:action_type].present?
    query = query.where { budget_type.eq(params[:budget_type]) } if params[:budget_type].present?
    query = query.where { year.eq(params[:year]) } if params[:year].present?

    query
  end

  scope :by_year, lambda { |year| where(year: year) if year.present? }
  scope :by_entity_id, lambda { |entity_id| where(entity_id: entity_id) if entity_id.present?}

  def to_s
    "#{code} - #{title}"
  end

  private

  def validate_dates
    return unless start_date && end_date

    if end_date <= start_date
      errors.add(:end_date, :must_be_greater_than_start_date)
    end
  end
end
