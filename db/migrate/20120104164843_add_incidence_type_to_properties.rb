class AddIncidenceTypeToProperties < ActiveRecord::Migration
  def change
    add_column :properties, :incidence_type, :string
  end
end
