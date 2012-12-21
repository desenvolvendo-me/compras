class AddPreambleToTrading < ActiveRecord::Migration
  def change
    add_column :compras_tradings, :preamble, :text
  end
end
