class AddIndexToLicitationProcessClassifications < ActiveRecord::Migration
  def change
    add_index :compras_licitation_process_classifications, :classifiable_id, :name => :clpc_classifiable_id
  end
end
