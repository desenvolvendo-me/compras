class DropStnOrdinances < ActiveRecord::Migration
  def change
    drop_table :stn_ordinances
  end
end
