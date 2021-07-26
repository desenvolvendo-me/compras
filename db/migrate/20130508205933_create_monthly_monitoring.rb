class CreateMonthlyMonitoring < ActiveRecord::Migration
  def change
    create_table :compras_monthly_monitorings do |t|
      t.integer :customer_id
      t.integer :prefecture_id
      t.integer :control_code
      t.integer :city_code
      t.integer :month
      t.integer :year
      t.string  :status
      t.string  :job_id
      t.string  :file
      t.string  :error_message
      t.text    :processing_errors

      t.timestamps
    end

    add_index :compras_monthly_monitorings, :customer_id
    add_index :compras_monthly_monitorings, :prefecture_id

    add_foreign_key :compras_monthly_monitorings, :unico_customers, column: :customer_id
    add_foreign_key :compras_monthly_monitorings, :unico_prefectures, column: :prefecture_id
  end
end

