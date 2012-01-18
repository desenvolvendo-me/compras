class RemoveColumnRequestPublicServicesCode < ActiveRecord::Migration
  def change
    remove_column :request_public_services, :code
  end
end
