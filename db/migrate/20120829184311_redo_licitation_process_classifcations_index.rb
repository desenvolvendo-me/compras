class RedoLicitationProcessClassifcationsIndex < ActiveRecord::Migration
  def change
    remove_index :compras_licitation_process_classifications, :name => :clpc_classifiable_id

    add_index :compras_licitation_process_classifications, [:classifiable_id, :classifiable_type], :name => :clpc_classifiable
  end
end
