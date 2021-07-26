class AccountsController < CrudController
  defaults :singleton => true, :instance_name => 'user', :class_name => 'User'

  def update
    update! { edit_resource_path }
  end

  protected

  def resource
    current_user
  end
end
