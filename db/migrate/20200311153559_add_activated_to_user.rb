class AddActivatedToUser < ActiveRecord::Migration
  def change
    add_column :compras_users, :activated,
      :boolean, :default => true
  end
end
