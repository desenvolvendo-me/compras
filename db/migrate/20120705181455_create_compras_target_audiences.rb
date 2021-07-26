class CreateComprasTargetAudiences < ActiveRecord::Migration
  def change
    create_table :compras_target_audiences do |t|
      t.string :specification
      t.text :observation

      t.timestamp
    end
  end
end
