class AddColumnHabilitationDateToBidders < ActiveRecord::Migration
  def change
    add_column :compras_bidders, :habilitation_date, :date
  end
end
