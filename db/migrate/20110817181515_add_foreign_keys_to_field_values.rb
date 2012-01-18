class AddForeignKeysToFieldValues < ActiveRecord::Migration
  def change
    add_foreign_key :field_values, :fields
    add_foreign_key :field_values, :properties
  end
end
