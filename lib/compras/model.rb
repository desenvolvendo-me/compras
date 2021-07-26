class Compras::Model < ActiveRecord::Base
  self.abstract_class = true
  self.table_name_prefix = 'compras_'

  def as_json(options = {})
    options[:methods] = Array(options[:methods]) << :to_s
    options[:except]  = Array(options[:except]) << :custom_data

    super
  end
end
