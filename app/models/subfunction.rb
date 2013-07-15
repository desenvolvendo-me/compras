class Subfunction < Accounting::Model
  attr_modal :code, :description

  attr_readonly :entity_id

  with_options :allow_blank => true do |allowing_blank|
    allowing_blank.validates :code, :numericality => true
    allowing_blank.validates :code, :description, :uniqueness => true
  end

  orderize :code

  def self.filter(params)
    query = scoped
    query = query.where { code.eq(params[:code]) } if params[:code].present?
    query = query.where { description.eq(params[:description]) } if params[:description].present?
    query = query.where { year.eq(params[:year]) } if params[:year].present?

    query
  end

  scope :by_year, lambda { |year| where(year: year) if year.present? }
  scope :by_entity_id, lambda { |entity_id| where(entity_id: entity_id) if entity_id.present? }

  def to_s
    "#{code} - #{description}"
  end
end
