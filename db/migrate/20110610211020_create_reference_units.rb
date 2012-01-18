class CreateReferenceUnits < ActiveRecord::Migration
  def change
    create_table :reference_units do |t|
      t.string :name

      t.timestamps
    end
  end
end
