class AddPrecisionAndScaleToExtraCreditMovimentTypesValue < ActiveRecord::Migration
  def change
    change_column :extra_credit_moviment_types, :value, :decimal, :precision => 10, :scale => 2
  end
end
