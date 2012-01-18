class AddFactGeneratableTypeToDelayedCalculations < ActiveRecord::Migration
  def change
    add_column :delayed_calculations, :fact_generatable_type, :string
  end
end
