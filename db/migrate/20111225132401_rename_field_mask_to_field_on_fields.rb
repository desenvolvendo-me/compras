class RenameFieldMaskToFieldOnFields < ActiveRecord::Migration
  def change
    rename_column :fields, :field_mask, :mask
  end
end
