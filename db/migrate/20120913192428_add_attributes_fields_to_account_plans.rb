class AddAttributesFieldsToAccountPlans < ActiveRecord::Migration
  def change
    change_table :compras_account_plans do |t|
      t.string :nature_balance
      t.string :nature_information
      t.string :nature_balance_variation
      t.boolean :bookkeeping, :default => false
      t.string :surplus_indicator
      t.string :movimentation_kind
    end
  end
end
