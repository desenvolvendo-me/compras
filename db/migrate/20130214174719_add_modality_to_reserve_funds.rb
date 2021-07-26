class AddModalityToReserveFunds < ActiveRecord::Migration
  def change
    add_column :compras_reserve_funds, :modality, :string
  end
end
