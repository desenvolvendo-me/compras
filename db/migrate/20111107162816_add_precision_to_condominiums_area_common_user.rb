class AddPrecisionToCondominiumsAreaCommonUser < ActiveRecord::Migration
  def change
    change_column :condominiums, :area_common_user, :decimal, :precision => 10, :scale => 2
  end
end
