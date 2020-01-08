class CreateAdditiveSolicitations < ActiveRecord::Migration
  def change
    create_table "compras_additive_solicitations" do |t|
      t.string  "number"
      t.string   "year"
      t.references :creditor
      t.references :licitation_process
      t.references :department

      t.timestamps
    end
  end
end
