class UsersController < CrudController
  protected

  def create_resource(object)
    object.confirm! if super
  end

  def end_of_association_chain
    User.employee
  end
end
