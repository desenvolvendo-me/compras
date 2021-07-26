class AddEmployeeIdToPriceCollectionProposals < ActiveRecord::Migration
  def up
    add_column :compras_price_collection_proposals, :employee_id, :integer

    add_index :compras_price_collection_proposals, :employee_id

    add_foreign_key :compras_price_collection_proposals, :compras_employees,
      column: :employee_id, name: :cpcp_employee_id_fk
  end

  def down
    remove_column :compras_price_collection_proposals, :employee_id
  end
end
