class AddLoginToUsers < ActiveRecord::Migration
  def change
    add_column :users, :login, :string
    add_index :users, :login, :unique => true

    say_with_time 'create_login' do
      User.reset_column_information

      User.find_each do |user|
        user.update_attribute(:login, user.email.split('@').first)
      end
    end
  end
end
