class CreateAdditionalCreditOpeningMovimentTypes < ActiveRecord::Migration
  def change
    create_table :additional_credit_opening_moviment_types do |t|
      t.integer :additional_credit_opening_id
      t.integer :moviment_type_id
      t.integer :budget_allocation_id
      t.integer :capability_id
      t.float :value

      t.timestamps
    end

    add_index :additional_credit_opening_moviment_types, :additional_credit_opening_id, :name => 'index_acomt_aco_id'
    add_index :additional_credit_opening_moviment_types, :moviment_type_id, :name => 'index_acomt_moviment_type_id'
    add_index :additional_credit_opening_moviment_types, :budget_allocation_id, :name => 'index_acomt_budget_allocation_id'
    add_index :additional_credit_opening_moviment_types, :capability_id, :name => 'index_acomt_capability_id'

    add_foreign_key :additional_credit_opening_moviment_types, :additional_credit_openings, :name => 'acomt_aco_id_fk'
    add_foreign_key :additional_credit_opening_moviment_types, :moviment_types, :name => 'acomt_moviment_type_id_fk'
    add_foreign_key :additional_credit_opening_moviment_types, :budget_allocations, :name => 'acomt_budget_allocation_id_fk'
    add_foreign_key :additional_credit_opening_moviment_types, :capabilities, :name => 'acomt_capability_id_fk'
  end
end
