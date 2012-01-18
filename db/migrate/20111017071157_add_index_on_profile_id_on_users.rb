class AddIndexOnProfileIdOnUsers < ActiveRecord::Migration
  def change
    add_index :users, :profile_id
  end
end
