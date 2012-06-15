class CreateTableComprasRegularizationOrAdministrativeSanctions < ActiveRecord::Migration
  def change
    create_table "compras_regularization_or_administrative_sanctions" do |t|
      t.integer "creditor_id"
      t.integer "regularization_or_administrative_sanction_reason_id"
      t.date    "suspended_until"
      t.date    "occurrence"
    end

    add_index "compras_regularization_or_administrative_sanctions", ["creditor_id"], :name => "croas_creditor_id"
    add_index "compras_regularization_or_administrative_sanctions", ["regularization_or_administrative_sanction_reason_id"], :name => "croas_regularization_or_administrative_sanction_reason_id"
  end
end
