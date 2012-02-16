class CreateManagementUnits < ActiveRecord::Migration
  def change
    create_table :management_units do |t|
      t.string :description
      t.string :acronym
      t.string :status

      t.timestamps
    end
  end
end
