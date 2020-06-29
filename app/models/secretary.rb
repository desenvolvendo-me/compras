class Secretary < Compras::Model
  attr_accessible :name, :secretary_settings, :secretary_settings_attributes

  attr_modal :name, :employee_id
  #
  attr_accessor :employee, :employee_id

  has_many :contract_financials
  has_many :secretary_settings
  has_many :employees, through: :secretary_settings

  # belongs_to :employee


  accepts_nested_attributes_for :secretary_settings, :allow_destroy => true

  validate :employees_actives

  scope :term, lambda { |q|
    where { name.like("%#{q}%") }
  }

  scope :by_user, lambda { |current_user|
    joins(secretary_settings:[employee:[:user]]).where { compras_users.id.eq current_user }
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

  def self.filter(params)
    params[:employee_ids]&.delete('')
    query = scoped.joins { secretary_settings.outer.employee.outer.individual.outer.person.outer }
    query = query.select('compras_secretaries.id, compras_secretaries.name, unico_people.name as employee')
    query = query.where{ secretary_settings.employee_id.in(params[:employee_ids]) } if params[:employee_ids].present?
    query = query.where{ 'compras_secretaries.id = compras_secretary_settings.secretary_id' } if params[:employee_ids].present?
    query = query.where { name.matches "#{params[:name]}%" } if params[:name].present?


    query
  end

  private

  def employees_actives
    return unless secretary_settings.where(active: true).count > 1
    errors.add(:secretary_settings, 'Pode haver somente um funcionario ativo')
  end

end