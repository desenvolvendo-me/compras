class CreateAdministrationTypes < ActiveRecord::Migration
  def change
    create_table :administration_types do |t|
      t.string :code
      t.string :name
      t.string :administration
      t.string :organ_type
      t.references :legal_nature

      t.timestamps
    end
    add_index :administration_types, :legal_nature_id
    add_foreign_key :administration_types, :legal_natures
  end
end
