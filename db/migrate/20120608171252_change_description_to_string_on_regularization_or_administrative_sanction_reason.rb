class ChangeDescriptionToStringOnRegularizationOrAdministrativeSanctionReason < ActiveRecord::Migration
  def change
    change_column :regularization_or_administrative_sanction_reasons, :description, :string
  end
end
