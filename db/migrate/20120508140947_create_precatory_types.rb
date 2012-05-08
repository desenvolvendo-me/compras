class CreatePrecatoryTypes < ActiveRecord::Migration
  def change
    create_table :precatory_types do |t|
      t.string :description
      t.string :status
      t.date :deactivation_date

      t.timestamps
    end
  end
end
