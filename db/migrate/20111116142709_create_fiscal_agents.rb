class CreateFiscalAgents < ActiveRecord::Migration
  def change
    create_table :fiscal_agents do |t|
      t.integer :person_id
      t.string :registration
      t.string :professional_registration_number

      t.timestamps
    end

    add_index :fiscal_agents, :person_id
    add_foreign_key :fiscal_agents, :people
  end
end
