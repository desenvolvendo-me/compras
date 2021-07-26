class CreateTableComprasCreditorRepresentatives < ActiveRecord::Migration
  def change
    create_table "compras_creditor_representatives" do |t|
      t.integer "creditor_id"
      t.integer "representative_person_id"
    end

    add_index "compras_creditor_representatives", ["creditor_id"], :name => "ccr_creditor_id"
    add_index "compras_creditor_representatives", ["representative_person_id"], :name => "ccr_representative_person_id"
  end
end
