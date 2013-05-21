class Function < Accounting::Model
  attr_modal :code, :regulatory_act_id, :description

  belongs_to :regulatory_act

  delegate :vigor_date, :to => :regulatory_act, :allow_nil => true, :prefix => true

  orderize :code

  def self.filter(params)
    query = scoped
    query = query.where { code.eq(params[:code]) } if params[:code].present?
    query = query.where { regulatory_act_id.eq(params[:regulatory_act_id]) } if params[:regulatory_act_id].present?
    query = query.where { description.eq(params[:description]) } if params[:description].present?
    query = query.where { year.eq(params[:year]) } if params[:year].present?

    query
  end

  scope :by_year, lambda { |year| where(year: year) if year.present? }

  def to_s
    "#{code} - #{description}"
  end
end
