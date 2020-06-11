class Secretary < Compras::Model
  attr_accessible :name, :employee_id

  belongs_to :employee

  has_many :contract_financials

  scope :term, lambda { |q|
    where { name.like("%#{q}%") }
  }

  scope :by_user, lambda { |current_user|
    joins(employee:[:user]).where { compras_users.id.eq current_user }
  }

  scope :by_contract_expense, lambda { |expense, contract|
    joins(:contract_financials).
        where { contract_financials.contract_id.eq(contract) ||
            contract_financials.expense_id.eq(expense)}
  }

  orderize "id DESC"
  filterize

  def to_s
    "#{name}"
  end

end