class AddOptionsToCustomizationData < ActiveRecord::Migration
  def change
    add_column :financeiro_customization_data, :options, :text
  end
end
