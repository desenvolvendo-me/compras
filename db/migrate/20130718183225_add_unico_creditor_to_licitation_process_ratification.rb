class AddUnicoCreditorToLicitationProcessRatification < ActiveRecord::Migration
  def change
    add_column :compras_licitation_process_ratifications, :creditor_id, :integer

    add_index :compras_licitation_process_ratifications, :creditor_id
    add_foreign_key :compras_licitation_process_ratifications, :unico_creditors, column: :creditor_id
  end
end
