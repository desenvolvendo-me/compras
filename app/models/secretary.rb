class Secretary < Compras::Model
  attr_accessible :name, :employee_id

  belongs_to :employee

  scope :term, lambda { |q|
    where { name.like("%#{q}%") }
  }

  scope :by_user, lambda { |current_user|
    joins(employee:[:user]).where { compras_users.id.eq current_user }
  }

  orderize "id DESC"
  filterize

  def to_s
    "#{name}"
  end


end