class ExpenseDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :year,:organ,:unity,:expense_function,
              :expense_sub_function
end