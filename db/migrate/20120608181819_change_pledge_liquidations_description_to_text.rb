class ChangePledgeLiquidationsDescriptionToText < ActiveRecord::Migration
  def change
    change_column :pledge_liquidations, :description, :text
  end
end
