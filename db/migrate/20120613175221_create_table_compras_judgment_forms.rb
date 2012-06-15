class CreateTableComprasJudgmentForms < ActiveRecord::Migration
  def change
    create_table "compras_judgment_forms" do |t|
      t.string   "description"
      t.string   "kind"
      t.string   "licitation_kind"
      t.datetime "created_at",      :null => false
      t.datetime "updated_at",      :null => false
    end
  end
end
