class AddIndexToPolymorphicFields < ActiveRecord::Migration
  def change
    add_index :compras_price_collection_classifications, [:classifiable_id, :classifiable_type], :name => :cpcc_classifiable_id
    add_index :compras_users, [:authenticable_id, :authenticable_type]
  end
end
