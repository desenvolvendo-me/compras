class Secretary < Compras::Model
  attr_accessible :name, :employee_id, :secretary_settings, :secretary_settings_attributes

  belongs_to :employee

  has_many :contract_financials
  has_many :secretary_settings
  has_many :departments

  accepts_nested_attributes_for :secretary_settings, :allow_destroy => true

  validate :employees_actives

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

  scope :by_department, lambda {|q|
    joins{ departments }.where{ departments.id.eq(q) }.limit(1)
  }


  orderize "id DESC"
  filterize

  def to_s
    "#{name}"
  end

  private

  def employees_actives
    return unless secretary_settings.where(active: true).count > 1
    errors.add(:secretary_settings, 'Pode haver somente um funcionario ativo')
  end

end