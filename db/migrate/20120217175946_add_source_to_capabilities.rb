class AddSourceToCapabilities < ActiveRecord::Migration
  def change
    add_column :capabilities, :source, :string
  end
end
