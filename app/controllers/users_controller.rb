class UsersController < CrudController
  before_filter :block_non_employee, :only => [:edit, :update, :destroy]

  protected

  def block_non_employee
    return if resource.employee? || !resource.authenticable_type?

    raise Exceptions::Unauthorized
  end

  def create_resource object
    object.authenticable_type = AuthenticableType::EMPLOYEE

    object.confirm! if super
  end
end
