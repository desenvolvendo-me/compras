class CreateLegalTextsNatures < ActiveRecord::Migration
  def change
    create_table :legal_texts_natures do |t|
      t.string :name

      t.timestamps
    end
  end
end
