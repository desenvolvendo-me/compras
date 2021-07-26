class RemoveLegalReferences < ActiveRecord::Migration
  def change
    drop_table :compras_legal_references
  end
end
