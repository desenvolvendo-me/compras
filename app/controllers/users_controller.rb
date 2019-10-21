class UsersController < CrudController

  def create
    @user = build_resource
    @user.skip_confirmation! if @user.password.present?

    create! { collection_path }
  end

  protected

  def end_of_association_chain
    User.employee
  end
end
