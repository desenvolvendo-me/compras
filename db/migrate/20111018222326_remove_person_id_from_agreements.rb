class RemovePersonIdFromAgreements < ActiveRecord::Migration
  def change
    remove_column :agreements, :person_id
  end
end
