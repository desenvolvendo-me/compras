class RemoveResponsibleIdFromActiveDebts < ActiveRecord::Migration
  def change
    remove_column :active_debts, :responsible_id
  end
end
