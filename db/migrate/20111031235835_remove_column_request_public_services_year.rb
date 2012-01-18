class RemoveColumnRequestPublicServicesYear < ActiveRecord::Migration
  def change
    remove_column :request_public_services, :year
  end
end
