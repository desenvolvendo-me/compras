class CreateOtherRevenuePublicServiceCalculations < ActiveRecord::Migration
  def change
    create_table :other_revenue_public_service_calculations do |t|
      t.integer :other_revenue_id
      t.integer :public_service_calculation_id
      t.integer :quantity

      t.timestamps
    end

    add_foreign_key :other_revenue_public_service_calculations, :other_revenues
    add_foreign_key :other_revenue_public_service_calculations, :public_service_calculations, :name => :public_service_calculation_id_fk
  end
end
