class AddPolymorphicToResourceAnnul < ActiveRecord::Migration
  def change
    change_table :resource_annuls do |t|
      t.integer :resource_id
      t.string  :resource_type
    end
  end
end
