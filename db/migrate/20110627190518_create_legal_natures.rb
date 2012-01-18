class CreateLegalNatures < ActiveRecord::Migration
  def change
    create_table :legal_natures do |t|
      t.string :code
      t.string :name

      t.timestamps
    end
  end
end
