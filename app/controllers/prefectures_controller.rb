class PrefecturesController < CrudController
  defaults :singleton => true

  def show
    flash.keep

    if resource
      redirect_to edit_resource_path
    else
      redirect_to new_resource_path
    end
  end

  def create
    create! { resource_path }
  end

  def update
    update! { resource_path }
  end

  protected

  def resource
    get_resource_ivar || set_resource_ivar(end_of_association_chain.first)
  end

  def authorize_resource!
    authorize! action_name, controller_name.singularize
  end
end
