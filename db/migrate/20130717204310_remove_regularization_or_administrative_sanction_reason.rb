class RemoveRegularizationOrAdministrativeSanctionReason < ActiveRecord::Migration
  def change
    drop_table :compras_regularization_or_administrative_sanction_reasons
  end
end
