class CreateRegularizationOrAdministrativeSanctionReasons < ActiveRecord::Migration
  def change
    create_table :regularization_or_administrative_sanction_reasons do |t|
      t.text :description
      t.string :reason_type

      t.timestamps
    end
  end
end
