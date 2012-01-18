class CreateTypeImprovements < ActiveRecord::Migration
  def change
    create_table :type_improvements do |t|
      t.string :name

      t.timestamps
    end
  end
end
