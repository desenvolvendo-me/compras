class Descriptor < Compras::Model
  attr_accessible :period, :entity_id

  attr_modal :entity, :year

  belongs_to :entity

  orderize :period
  filterize

  def to_s
    "#{year} - #{entity}"
  end

  def year
    period.try(:year)
  end

  def month
    period.try(:month)
  end
end
