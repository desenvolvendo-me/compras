class UsersController < CrudController
  def new
    object = build_resource
    object.authenticable_type = AuthenticableType::EMPLOYEE

    super
  end

  def edit
    object = resource
    object.authenticable_type = AuthenticableType::EMPLOYEE unless object.authenticable_type?

    super
  end

  protected
  def create_resource object
    object.confirm! if super
  end
end
