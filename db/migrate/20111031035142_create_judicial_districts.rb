class CreateJudicialDistricts < ActiveRecord::Migration
  def change
    create_table :judicial_districts do |t|
      t.string :name

      t.timestamps
    end
  end
end
