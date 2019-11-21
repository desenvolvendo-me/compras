class ExpenseDecorator
  include Decore
  include Decore::Proxy
  include Decore::Header

  attr_header :destiny,:organ,:project_activity,
              :destine_type,:year
end