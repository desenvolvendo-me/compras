class ChangeFormatFieldToMaskInFields < ActiveRecord::Migration
  def up
    rename_column :fields, :format, :field_mask
  end

  def down
    rename_column :fields, :field_mask, :format
  end
end
