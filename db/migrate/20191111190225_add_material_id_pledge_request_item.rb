class AddMaterialIdPledgeRequestItem < ActiveRecord::Migration
  def up
    add_column :compras_pledge_request_items,
               :material_id, :integer
    add_index :compras_pledge_request_items, :material_id
    # add_foreign_key :compras_pledge_request_items,:unico_materials,
    #                 column: :material_id
  end

  def down
    remove_column :compras_pledge_request_items,
                  :material_id
  end
end
