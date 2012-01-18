class AddFactGeneratableToLowerPayments < ActiveRecord::Migration
  def change
    add_column :lower_payments, :fact_generatable_id, :integer
    add_column :lower_payments, :fact_generatable_type, :string
    add_index :lower_payments, [:fact_generatable_id, :fact_generatable_type], :name => :fact_generatable
  end
end
