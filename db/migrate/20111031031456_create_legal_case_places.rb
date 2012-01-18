class CreateLegalCasePlaces < ActiveRecord::Migration
  def change
    create_table :legal_case_places do |t|
      t.string :name

      t.timestamps
    end
  end
end
