class CreateStageProcesses < ActiveRecord::Migration
  def change
    create_table :compras_stage_processes do |t|
      t.string :description
      t.string :type_of_purchase

      t.timestamps
    end
  end
end
