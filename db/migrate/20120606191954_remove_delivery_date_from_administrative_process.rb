class RemoveDeliveryDateFromAdministrativeProcess < ActiveRecord::Migration
  def change
    remove_column :administrative_processes, :delivery_date
  end
end
