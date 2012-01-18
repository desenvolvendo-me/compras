class CreateIncidenceRevenues < ActiveRecord::Migration
  def change
    create_table :incidence_revenues do |t|
      t.string :name

      t.timestamps
    end
  end
end
