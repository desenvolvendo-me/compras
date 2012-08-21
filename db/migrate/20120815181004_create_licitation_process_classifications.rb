class CreateLicitationProcessClassifications < ActiveRecord::Migration
  def change
    create_table :compras_licitation_process_classifications do |t|
      t.references :licitation_process_bidder
      t.decimal :unit_value, :precision => 10, :scale => 2
      t.decimal :total_value, :precision => 10, :scale => 2
      t.integer :classification
      t.string :situation
      t.string :classifiable_type
      t.integer :classifiable_id

      t.timestamps
    end

    add_index :compras_licitation_process_classifications, :licitation_process_bidder_id, :name => :clpc_bidder_id

    add_foreign_key :compras_licitation_process_classifications, :compras_licitation_process_bidders,
                    :column => :licitation_process_bidder_id, :name => :clpc_clpb_fk
  end
end
