class CreateResponsibleAgencies < ActiveRecord::Migration
  def change
    create_table :responsible_agencies do |t|
      t.string :name
      t.text :description

      t.timestamps
    end
  end
end
