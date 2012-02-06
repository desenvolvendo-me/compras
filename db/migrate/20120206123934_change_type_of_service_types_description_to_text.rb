class ChangeTypeOfServiceTypesDescriptionToText < ActiveRecord::Migration
  def change
    change_column :service_types, :description, :text
  end
end
