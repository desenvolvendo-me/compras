class ConfirmAllTheExistentsUsers < ActiveRecord::Migration
  def change
    User.find_each do |user|
      user.confirm!
    end
  end
end
