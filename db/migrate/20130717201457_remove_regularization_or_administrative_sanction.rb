class RemoveRegularizationOrAdministrativeSanction < ActiveRecord::Migration
  def change
    drop_table :compras_regularization_or_administrative_sanctions
  end
end
