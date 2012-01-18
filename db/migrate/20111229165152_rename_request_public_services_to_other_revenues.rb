class RenameRequestPublicServicesToOtherRevenues < ActiveRecord::Migration
  def change
    rename_table :request_public_services, :other_revenues
  end
end
