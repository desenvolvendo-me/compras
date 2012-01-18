class RenameIncidenceTypeToPropertyIncidenceTypeAtProperties < ActiveRecord::Migration
  def change
    rename_column :properties, :incidence_type, :property_incidence_type
  end
end
