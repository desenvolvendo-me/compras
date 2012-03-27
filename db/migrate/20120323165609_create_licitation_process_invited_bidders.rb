class CreateLicitationProcessInvitedBidders < ActiveRecord::Migration
  def change
    create_table :licitation_process_invited_bidders do |t|
      t.references :licitation_process
      t.references :provider
      t.string :protocol
      t.date :protocol_date
      t.date :receipt_date
      t.boolean :auto_convocation, :default => false

      t.timestamps
    end

    add_index :licitation_process_invited_bidders, :licitation_process_id, :name => 'lpib_licitation_process_id'
    add_index :licitation_process_invited_bidders, :provider_id, :name => 'lpib_provider_id'
    add_foreign_key :licitation_process_invited_bidders, :licitation_processes, :name => 'lpib_licitation_process_fk'
    add_foreign_key :licitation_process_invited_bidders, :providers, :name => 'lpib_provider_fk'
  end
end
