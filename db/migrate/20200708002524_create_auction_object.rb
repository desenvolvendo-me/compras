class CreateAuctionObject < ActiveRecord::Migration
  def change
    create_table "compras_management_objects" do |t|
      t.string   "description"
      t.string   "status"
      t.text     "object"
      t.timestamps
    end
  end
end
