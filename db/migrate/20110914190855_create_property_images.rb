class CreatePropertyImages < ActiveRecord::Migration
  def change
    create_table :property_images do |t|
      t.integer :property_id
      t.string :image

      t.timestamps
    end

    add_index :property_images, :property_id
    add_foreign_key :property_images, :properties
  end
end
