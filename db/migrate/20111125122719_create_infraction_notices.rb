class CreateInfractionNotices < ActiveRecord::Migration
  def change
    create_table :infraction_notices do |t|
      t.references :incidence
      t.references :source
      t.references :fiscal_agent
      t.references :responsible_agency
      t.integer :number_of_notice
      t.integer :number_of_process
      t.integer :days_for_payment
      t.string :incidence_type
      t.string :source_type
      t.string :situation
      t.string :notice_hour
      t.date :notice_date
      t.text :description

      t.timestamps
    end
    add_index :infraction_notices, [:incidence_id, :incidence_type]
    add_index :infraction_notices, [:source_id, :source_type]

    add_index :infraction_notices, :fiscal_agent_id
    add_foreign_key :infraction_notices, :fiscal_agents

    add_index :infraction_notices, :responsible_agency_id
    add_foreign_key :infraction_notices, :responsible_agencies
  end
end
