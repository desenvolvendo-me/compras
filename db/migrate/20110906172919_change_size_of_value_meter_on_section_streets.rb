class ChangeSizeOfValueMeterOnSectionStreets < ActiveRecord::Migration
  def up
    change_column :section_streets, :value_meter, :decimal, :precision => 20, :scale => 2
  end

  def down
    change_column :section_streets, :value_meter, :decimal, :precision => 5, :scale => 2
  end
end