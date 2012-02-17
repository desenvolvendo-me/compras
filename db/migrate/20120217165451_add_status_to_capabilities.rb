class AddStatusToCapabilities < ActiveRecord::Migration
  def change
    add_column :capabilities, :status, :string
  end
end
