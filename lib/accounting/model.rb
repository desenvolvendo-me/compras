class Accounting::Model < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = 'accounting_'
end
