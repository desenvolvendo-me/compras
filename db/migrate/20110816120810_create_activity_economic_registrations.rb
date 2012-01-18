class CreateActivityEconomicRegistrations < ActiveRecord::Migration
  def change
    create_table :activity_economic_registrations do |t|
      t.references :economic_registration
      t.references :branch_activity
      t.boolean :major_activitiy
      t.date :start_date
      t.date :end_date

      t.timestamps
    end
    add_index :activity_economic_registrations, :economic_registration_id, :name => "activity_economic_registration_idx"
    add_index :activity_economic_registrations, :branch_activity_id, :name => "active_economic_registrationbranch_activity_idx"
    add_foreign_key :activity_economic_registrations, :economic_registrations, :name => "activity_economic_registrations_economic_registrations_fk"
    add_foreign_key :activity_economic_registrations, :branch_activities, :name => "activity_economic_registrations_branch_activities_fk"
  end
end
