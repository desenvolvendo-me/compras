class UsersController < CrudController
  has_scope :term, :allow_blank => true

  def create
    @user = build_resource
    @user.skip_confirmation! if @user.password.present?

    create! { collection_path }
  end

  # protected
  #
  # TODO comentado porque não tava permitindo a busca pelo scope term
  # verificar impacto
  # def end_of_association_chain
  #   User.employee
  # end

end
