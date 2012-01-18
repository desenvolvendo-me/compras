class AgreementOperationsPeople < ActiveRecord::Migration
  def change
    create_table :agreement_operations_people, :id => false do |t|
      t.references :agreement_operation, :person
    end

    add_index :agreement_operations_people, :agreement_operation_id
    add_index :agreement_operations_people, :person_id
    add_index :agreement_operations_people, [:person_id, :agreement_operation_id], :name => 'fk_person_id_and_agreement_operation_id'
    add_foreign_key :agreement_operations_people, :people
    add_foreign_key :agreement_operations_people, :agreement_operations
  end
end
