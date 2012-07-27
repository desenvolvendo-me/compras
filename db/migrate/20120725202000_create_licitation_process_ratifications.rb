class CreateLicitationProcessRatifications < ActiveRecord::Migration
  def change
    create_table :compras_licitation_process_ratifications do |t|
      t.references :licitation_process
      t.references :licitation_process_bidder
      t.date :ratification_date
      t.date :adjudication_date

      t.timestamps
    end

    add_index :compras_licitation_process_ratifications, :licitation_process_id, :name => :clpr_licitation_process
    add_index :compras_licitation_process_ratifications, :licitation_process_bidder_id, :name => :clpr_bidder

    add_foreign_key :compras_licitation_process_ratifications, :compras_licitation_processes,
                    :column => :licitation_process_id, :name => :clpr_licitation_process_fk

    add_foreign_key :compras_licitation_process_ratifications, :compras_licitation_process_bidders,
                    :column => :licitation_process_bidder_id, :name => :clpr_bidder_fk
  end
end
