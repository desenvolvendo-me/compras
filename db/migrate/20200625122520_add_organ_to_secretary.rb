class AddOrganToSecretary < ActiveRecord::Migration
  def change
    add_column :compras_secretaries, :unit_id, :integer

    add_foreign_key :compras_secretaries, :compras_organs, column: :unit_id
  end
end
