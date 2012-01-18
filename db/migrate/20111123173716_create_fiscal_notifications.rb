class CreateFiscalNotifications < ActiveRecord::Migration
  def change
    create_table :fiscal_notifications do |t|
      t.integer :year
      t.references :fiscal_nature
      t.string :situation
      t.integer :incidence_id
      t.string :incidence_type
      t.string :fiscal_nature_incidence
      t.references :fiscal_agent
      t.references :responsible_agency
      t.date :notification_at
      t.date :notification_date
      t.string :notification_hour
      t.text :description

      t.timestamps
    end
    add_index :fiscal_notifications, :fiscal_nature_id
    add_index :fiscal_notifications, :fiscal_agent_id
    add_index :fiscal_notifications, :responsible_agency_id
    add_foreign_key :fiscal_notifications, :fiscal_natures
    add_foreign_key :fiscal_notifications, :fiscal_agents
    add_foreign_key :fiscal_notifications, :responsible_agencies
    add_index :fiscal_notifications, [:incidence_id, :incidence_type]
  end
end
