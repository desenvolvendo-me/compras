class AddControlFractionationToExtendedPrefectures < ActiveRecord::Migration
  def change
    add_column :compras_extended_prefectures, :control_fractionation, :boolean, default: true
  end
end
