class CreateServiceTypes < ActiveRecord::Migration
  def change
    create_table :service_types do |t|
      t.integer :tce_code
      t.text :description
      t.string :goal

      t.timestamps
    end
  end
end
