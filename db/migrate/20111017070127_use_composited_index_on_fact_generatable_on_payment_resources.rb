class UseCompositedIndexOnFactGeneratableOnPaymentResources < ActiveRecord::Migration
  def up
    remove_index :payment_resources, :fact_generatable_id
    remove_index :payment_resources, :fact_generatable_type

    add_index :payment_resources, [:fact_generatable_id, :fact_generatable_type], :name => :index_payment_resources_on_fact_generatable
  end

  def down
    remove_index :payment_resources, :name => :index_payment_resources_on_fact_generatable

    add_index :payment_resources, :fact_generatable_type
    add_index :payment_resources, :fact_generatable_id
  end
end
