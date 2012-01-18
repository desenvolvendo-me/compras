class CreateTableParcelsRevenues < ActiveRecord::Migration
  def change
    create_table :parcels_revenues, :id => false do |t|
      t.references :parcel
      t.references :revenue
    end

    add_foreign_key :parcels_revenues, :parcels
    add_foreign_key :parcels_revenues, :revenues
  end
end
