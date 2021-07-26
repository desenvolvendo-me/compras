class CreateAccountPlanConfigurations < ActiveRecord::Migration
  def change
    create_table :compras_account_plan_configurations do |t|
      t.integer :year
      t.references :state
      t.string :description

      t.timestamps
    end

    add_index :compras_account_plan_configurations, :state_id, :name => :capc_state

    add_foreign_key :compras_account_plan_configurations, :unico_states,
                    :column => :state_id, :name => :capc_cs_fk
  end
end
