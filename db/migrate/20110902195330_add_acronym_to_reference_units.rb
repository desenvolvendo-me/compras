class AddAcronymToReferenceUnits < ActiveRecord::Migration
  def change
    add_column :reference_units, :acronym, :string
  end
end