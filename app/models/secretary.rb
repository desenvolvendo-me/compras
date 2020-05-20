class Secretary < Compras::Model
  attr_accessible :name, :employee_id

  belongs_to :employee

  scope :term, lambda { |q|
    where { name.like("%#{q}%") }
  }

  orderize "id DESC"
  filterize

  def to_s
    "#{name}"
  end

end