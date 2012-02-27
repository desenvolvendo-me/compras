class CreateReserveAllocationTypes < ActiveRecord::Migration
  def change
    create_table :reserve_allocation_types do |t|
      t.string :description
      t.string :status

      t.timestamps
    end
  end
end
