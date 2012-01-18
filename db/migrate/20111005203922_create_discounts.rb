class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.string :name
      t.text :description
      t.decimal :percent, :precision => 5, :scale => 2

      t.timestamps
    end
  end
end
