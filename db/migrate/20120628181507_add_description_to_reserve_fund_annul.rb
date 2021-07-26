class AddDescriptionToReserveFundAnnul < ActiveRecord::Migration
  def change
    add_column :compras_reserve_fund_annuls, :description, :text
  end
end
