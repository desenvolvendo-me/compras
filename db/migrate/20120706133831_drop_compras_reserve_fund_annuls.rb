class DropComprasReserveFundAnnuls < ActiveRecord::Migration
  def change
    drop_table :compras_reserve_fund_annuls
  end
end
