class RemoveRegistrableFromRegistrationTerms < ActiveRecord::Migration
  def change
    change_table :registration_terms do |t|
      t.remove :registrable_id
      t.remove :registrable_type
    end
  end
end
