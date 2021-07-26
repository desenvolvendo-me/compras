class CreatePurchaseSolicitationMaterial < ActiveRecord::Migration
  def up
    create_table :compras_purchase_solicitation_materials do |t|
      t.references :purchase_solicitation
      t.references :material

      t.timestamps
    end
  end

  def down
  end
end
