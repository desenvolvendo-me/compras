class RemoveEmployeeFromUsers < ActiveRecord::Migration
  class User < ActiveRecord::Base
  end

  def up
    User.where('employee_id IS NOT NULL').find_each do |user|
      user.update_attributes :authenticable_id => user.employee_id, :authenticable_type => AuthenticableType::EMPLOYEE
    end
    
    remove_column :users, :employee_id
  end

  def down
    add_column :user, :employee_id, :integer
    User.where(:authenticable_type => AuthenticableType::EMPLOYEE).find_each do |user|
      user.update_attribute :employee_id, user.authenticable_id
    end
  end
end
