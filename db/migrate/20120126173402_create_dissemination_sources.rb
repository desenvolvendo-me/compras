class CreateDisseminationSources < ActiveRecord::Migration
  def change
    create_table :dissemination_sources do |t|
      t.integer :communication_source_id
      t.string :description

      t.timestamps
    end
  end
end
