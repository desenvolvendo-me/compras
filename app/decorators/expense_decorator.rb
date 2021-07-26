class ExpenseDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :year, :expense_function,
              :expense_sub_function, :project_activity, :nature_expense_nature, :resource_source

  def nature_expense_nature
    nature_expense&.nature
  end
end