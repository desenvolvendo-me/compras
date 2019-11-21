class Department < Compras::Model
  belongs_to :purchasing_unit

  attr_accessible :description,:purchasing_unit_id

  validates :description, :presence => true

  orderize :description
  filterize

  scope :term, lambda { |q|
    where { description.like("#{q}%") }
  }

  scope :limit, lambda { |q| limit(q) }

  def to_s
    "#{description}"
  end

end
