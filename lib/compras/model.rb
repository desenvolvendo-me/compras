class Compras::Model < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = 'compras_'
end
