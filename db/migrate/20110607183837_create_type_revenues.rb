class CreateTypeRevenues < ActiveRecord::Migration
  def change
    create_table :type_revenues do |t|
      t.string :name

      t.timestamps
    end
  end
end
