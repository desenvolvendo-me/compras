class AddColumnJustificationToPurchaseProcess < ActiveRecord::Migration
  def change
    add_column :compras_licitation_processes, :justification, :text
  end
end
