class CreateSpecialEntries < ActiveRecord::Migration
  def change
    create_table :special_entries do |t|
      t.timestamps
    end
  end
end
