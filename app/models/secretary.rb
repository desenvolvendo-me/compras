class Secretary < Compras::Model
  attr_accessible :name, :employee_id

  belongs_to :employee

  orderize "id DESC"
  filterize

  def to_s
    "#{name}"
  end

end