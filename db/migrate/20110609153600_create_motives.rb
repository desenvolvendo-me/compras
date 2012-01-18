class CreateMotives < ActiveRecord::Migration
  def change
    create_table :motives do |t|
      t.text :description

      t.timestamps
    end
  end
end
