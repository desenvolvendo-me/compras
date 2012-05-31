class AddAuthenticableToUsers < ActiveRecord::Migration
  def change
    add_column :users, :authenticable_id, :integer
    add_column :users, :authenticable_type, :string
  end
end
