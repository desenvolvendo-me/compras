class CreateTableComprasLinks < ActiveRecord::Migration
  def change
    create_table "compras_links" do |t|
      t.string "controller_name"
    end
  end
end
