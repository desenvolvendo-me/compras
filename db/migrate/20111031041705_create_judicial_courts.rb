class CreateJudicialCourts < ActiveRecord::Migration
  def change
    create_table :judicial_courts do |t|
      t.string :name

      t.timestamps
    end
  end
end
