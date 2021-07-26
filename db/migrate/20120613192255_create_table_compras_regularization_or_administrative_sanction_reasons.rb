class CreateTableComprasRegularizationOrAdministrativeSanctionReasons < ActiveRecord::Migration
  def change
    create_table "compras_regularization_or_administrative_sanction_reasons" do |t|
      t.string   "description"
      t.string   "reason_type"
      t.datetime "created_at",  :null => false
      t.datetime "updated_at",  :null => false
    end
  end
end
