class CreateStatusMovimentations < ActiveRecord::Migration
  def change
    create_table :status_movimentations do |t|
      t.string :new_status
      t.string :old_status
      t.string :status_movimentable_type
      t.integer :status_movimentable_id
      t.string :status_modificator_type
      t.integer :status_modificator_id

      t.timestamps
    end

    add_index :status_movimentations, :status_movimentable_type
    add_index :status_movimentations, :status_movimentable_id
    add_index :status_movimentations, :status_modificator_id
    add_index :status_movimentations, :status_modificator_type
  end
end
