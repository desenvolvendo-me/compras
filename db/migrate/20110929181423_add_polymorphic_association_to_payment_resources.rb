class AddPolymorphicAssociationToPaymentResources < ActiveRecord::Migration
  def change
    add_column :payment_resources, :fact_generatable_id, :integer
    add_column :payment_resources, :fact_generatable_type, :string
    add_index  :payment_resources, :fact_generatable_id
    add_index  :payment_resources, :fact_generatable_type
  end
end
