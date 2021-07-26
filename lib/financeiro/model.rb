class Financeiro::Model < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = 'financeiro_'
end
