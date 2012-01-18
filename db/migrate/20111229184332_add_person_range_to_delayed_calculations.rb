class AddPersonRangeToDelayedCalculations < ActiveRecord::Migration
  def change
    add_column :delayed_calculations, :person_range, :string
  end
end
