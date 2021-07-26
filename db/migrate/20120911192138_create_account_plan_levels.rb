class CreateAccountPlanLevels < ActiveRecord::Migration
  def change
    create_table :compras_account_plan_levels do |t|
      t.integer :account_plan_configuration_id
      t.integer  :level
      t.string   :description
      t.integer  :digits
      t.string   :separator

      t.timestamps
    end

    add_index :compras_account_plan_levels, :account_plan_configuration_id,
              :name => :compras_apl_plan_configuration_index

    add_foreign_key :compras_account_plan_levels,
                    :compras_account_plan_configurations,
                    :column => :account_plan_configuration_id
  end
end
