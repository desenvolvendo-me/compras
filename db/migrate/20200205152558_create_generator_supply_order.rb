class CreateGeneratorSupplyOrder < ActiveRecord::Migration
  def change
    create_table :compras_generator_supply_orders do |t|
      t.integer :customer_id
      t.integer :prefecture_id
      t.integer :control_code
      t.integer :city_code
      t.string  :status
      t.string  :job_id
      t.string  :file
      t.string  :error_message
      t.text    :processing_errors

      t.timestamps
    end

  end
end
