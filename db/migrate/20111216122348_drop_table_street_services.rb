class DropTableStreetServices < ActiveRecord::Migration
  def change
    drop_table :street_services
  end
end
