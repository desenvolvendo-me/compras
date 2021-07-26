class CreateTableComprasLicitationObjects < ActiveRecord::Migration
  def change
    create_table "compras_licitation_objects" do |t|
      t.string   "description"
      t.integer  "year"
      t.decimal  "purchase_invitation_letter",  :precision => 10, :scale => 2
      t.decimal  "purchase_taking_price",       :precision => 10, :scale => 2
      t.decimal  "purchase_public_concurrency", :precision => 10, :scale => 2
      t.decimal  "build_invitation_letter",     :precision => 10, :scale => 2
      t.decimal  "build_taking_price",          :precision => 10, :scale => 2
      t.decimal  "build_public_concurrency",    :precision => 10, :scale => 2
      t.decimal  "special_auction",             :precision => 10, :scale => 2
      t.decimal  "special_unenforceability",    :precision => 10, :scale => 2
      t.decimal  "special_contest",             :precision => 10, :scale => 2
      t.datetime "created_at",                                                 :null => false
      t.datetime "updated_at",                                                 :null => false
    end
  end
end
