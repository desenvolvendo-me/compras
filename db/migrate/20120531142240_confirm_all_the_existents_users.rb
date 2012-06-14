class ConfirmAllTheExistentsUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def change
    User.find_each do |user|
      user.confirm!
    end
  end
end
