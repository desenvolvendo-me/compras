class CreateAccountPlans < ActiveRecord::Migration
  def change
    create_table :compras_account_plans do |t|
      t.references :account_plan_configuration
      t.string :checking_account
      t.string :title
      t.text :function

      t.timestamps
    end

    add_index :compras_account_plans, :account_plan_configuration_id

    add_foreign_key :compras_account_plans,
                    :compras_account_plan_configurations,
                    :column => :account_plan_configuration_id
  end
end
