class CreateMovimentationTypes < ActiveRecord::Migration
  def change
    create_table :movimentation_types do |t|
      t.string :acronym
      t.string :name

      t.timestamps
    end
  end
end
