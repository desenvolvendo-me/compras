class CreatePaymentResourceReactivations < ActiveRecord::Migration
  def change
    create_table :payment_resource_reactivations do |t|
      t.string :payment_resource_ids
      t.string :fact_generatable_ids
      t.string :fact_generatable_type
      t.text :comment
      t.integer :motive_id

      t.timestamps
    end

    add_index :payment_resource_reactivations, :motive_id
    add_foreign_key :payment_resource_reactivations, :motives
  end
end
