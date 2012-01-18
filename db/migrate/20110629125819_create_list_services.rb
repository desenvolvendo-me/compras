class CreateListServices < ActiveRecord::Migration
  def change
    create_table :list_services do |t|
      t.string :name
      t.string :code
      t.decimal :aliquot, :precision => 5, :scale => 2

      t.timestamps
    end
  end
end
