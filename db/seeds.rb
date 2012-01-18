# encoding: utf-8
ActiveRecord::Base.transaction do
  User.create!(:name => "Tributário", :email => "tributario@example.com", :login => "tributario", :password => "123456", :password_confirmation => "123456") do |user|
    user.administrator = true
  end
end
