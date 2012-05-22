class CreateSignatures < ActiveRecord::Migration
  def change
    create_table :signatures do |t|
      t.references :person
      t.references :position

      t.timestamps
    end

    add_index :signatures, :person_id
    add_index :signatures, :position_id

    add_foreign_key :signatures, :people
    add_foreign_key :signatures, :positions
  end
end
