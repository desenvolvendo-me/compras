class AddPrecisionToCondominiumsBuiltArea < ActiveRecord::Migration
  def change
    change_column :condominiums, :built_area, :decimal, :precision => 10, :scale => 2
  end
end
