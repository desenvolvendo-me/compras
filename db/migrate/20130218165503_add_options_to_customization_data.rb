class AddOptionsToCustomizationData < ActiveRecord::Migration
  def change
    unless ActiveRecord::Base.connection.column_exists?(:financeiro_customization_data, :options)
      add_column :financeiro_customization_data, :options, :text
    end
  end
end
