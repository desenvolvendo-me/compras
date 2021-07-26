class CreateTableComprasCreditorSecondaryCnaes < ActiveRecord::Migration
  def change
    create_table "compras_creditor_secondary_cnaes" do |t|
      t.integer "creditor_id"
      t.integer "cnae_id"
    end

    add_index "compras_creditor_secondary_cnaes", ["cnae_id"], :name => "ccsc_cnae_id"
    add_index "compras_creditor_secondary_cnaes", ["creditor_id"], :name => "ccsc_creditor_id"
  end
end
