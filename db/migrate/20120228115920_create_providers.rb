class CreateProviders < ActiveRecord::Migration
  def change
    create_table :providers do |t|
      t.references :person

      t.timestamps
    end

    add_index :providers, :person_id
    add_foreign_key :providers, :people
  end
end
