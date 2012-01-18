class AgreementOperationsRevenues < ActiveRecord::Migration
  def change
    create_table :agreement_operations_revenues, :id => false do |t|
      t.references :agreement_operation, :revenue
    end

    add_index :agreement_operations_revenues, :agreement_operation_id
    add_index :agreement_operations_revenues, :revenue_id
    add_index :agreement_operations_revenues, [:revenue_id, :agreement_operation_id], :name => 'fk_revenue_id_and_agreement_operation_id'
    add_foreign_key :agreement_operations_revenues, :revenues
    add_foreign_key :agreement_operations_revenues, :agreement_operations
  end
end
