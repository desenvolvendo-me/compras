class CreateUrbanServices < ActiveRecord::Migration
  def change
    create_table :urban_services do |t|
      t.string :year
      t.references :street
      t.references :section_street

      t.timestamps
    end
    add_index :urban_services, :street_id
    add_index :urban_services, :section_street_id
  end
end
