class AddSourceToComprasMovimentTypes < ActiveRecord::Migration
  def change
    add_column :compras_moviment_types, :source, :string
  end
end
