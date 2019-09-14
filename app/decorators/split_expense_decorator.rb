class ExpliteExpenseDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :code, :description, :function_account
end
