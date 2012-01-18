class AddPersonIdsToAgreementOperations < ActiveRecord::Migration
  def change
    add_column :agreement_operations, :person_ids, :string
  end
end
