class CreateCondominiumTypes < ActiveRecord::Migration
  def change
    create_table :condominium_types do |t|
      t.string :name

      t.timestamps
    end
  end
end
