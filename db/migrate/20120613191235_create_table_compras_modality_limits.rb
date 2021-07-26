class CreateTableComprasModalityLimits < ActiveRecord::Migration
  def change
    create_table "compras_modality_limits" do |t|
      t.string   "ordinance_number"
      t.date     "published_date"
      t.decimal  "without_bidding",         :precision => 10, :scale => 2
      t.decimal  "invitation_letter",       :precision => 10, :scale => 2
      t.decimal  "taken_price",             :precision => 10, :scale => 2
      t.decimal  "public_competition",      :precision => 10, :scale => 2
      t.decimal  "work_without_bidding",    :precision => 10, :scale => 2
      t.decimal  "work_invitation_letter",  :precision => 10, :scale => 2
      t.decimal  "work_taken_price",        :precision => 10, :scale => 2
      t.decimal  "work_public_competition", :precision => 10, :scale => 2
      t.datetime "created_at",                                             :null => false
      t.datetime "updated_at",                                             :null => false
      t.date     "validity_beginning"
    end
  end
end
