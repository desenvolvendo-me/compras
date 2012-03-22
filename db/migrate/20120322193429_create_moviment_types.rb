class CreateMovimentTypes < ActiveRecord::Migration
  def change
    create_table :moviment_types do |t|
      t.string :name
      t.string :operation
      t.string :character

      t.timestamps
    end
  end
end
