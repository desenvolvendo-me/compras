class AddUserToPeople < ActiveRecord::Migration
  def change
    add_column :unico_companies,
               :user_id, :integer
    add_index :unico_companies, :user_id
    add_foreign_key :unico_companies, :compras_users,
                    :column => :user_id
  end
end
