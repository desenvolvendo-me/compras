class CreateTypeInterests < ActiveRecord::Migration
  def change
    create_table :type_interests do |t|
      t.string :name

      t.timestamps
    end
  end
end
