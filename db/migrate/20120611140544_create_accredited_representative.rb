class CreateAccreditedRepresentative < ActiveRecord::Migration
  def change
    create_table :accredited_representatives do |t|
      t.references :person
      t.references :licitation_process_bidder
    end

    add_index :accredited_representatives, :person_id
    add_index :accredited_representatives, :licitation_process_bidder_id, :name => 'ar_licitation_process_bidder_id'

    add_foreign_key :accredited_representatives, :people
    add_foreign_key :accredited_representatives, :licitation_process_bidders, :name => 'ar_licitation_process_bidder_fk'
  end
end
