class ChangePersonIdFkInEconomicRegistrationToReferencePeople < ActiveRecord::Migration
  def up
    remove_foreign_key :economic_registrations, :column => :person_id
    add_foreign_key :economic_registrations, :people
  end

  def down
    remove_foreign_key :economic_registrations, :column => :person_id
    add_foreign_key :economic_registrations, :individuals, :column => :person_id
  end
end
