class ChangeTableNameTypeOptionsToOptions < ActiveRecord::Migration
  def change
    rename_table :type_options, :options
  end
end
