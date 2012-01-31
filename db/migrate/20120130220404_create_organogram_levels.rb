class CreateOrganogramLevels < ActiveRecord::Migration
  def change
    create_table :organogram_levels do |t|
      t.integer :configuration_organogram_id
      t.integer :level
      t.string :name
      t.integer :digits
      t.string :organogram_separator
      t.timestamps
    end

    add_index :organogram_levels, :configuration_organogram_id
    add_foreign_key :organogram_levels, :configuration_organograms
  end
end
