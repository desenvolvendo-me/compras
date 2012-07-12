class ResourceAnnulsController < CrudController
  defaults :resource_class => ResourceAnnul

  actions :all, :except => [:update, :destroy, :index]

  helper_method :edit_parent_path, :parent_model_name

  def new
    object = build_resource
    object.date = Date.current
    object.employee = current_user.authenticable

    validate_parent!(object)

    super
  end

  def create
    create!{ edit_parent_path }
  end

  def edit_parent_path
    send "edit_#{parent_model_name}_path", resource.annullable
  end

  def parent_model_name
    controller_name.sub('_annuls', '')
  end

  protected

  def annul(object)
    ObjectAnnulment.new(object.annullable).annul!
  end

  def create_resource(object)
    validate_parent!(object)

    annul(object)

    super
  end

  def end_of_association_chain
    return super unless annullable_id

    ResourceAnnul.where(:annullable_id => annullable_id, :annullable_type => parent_class)
  end

  def annullable_id
    params[:annullable_id]
  end

  def parent_class
    parent_model_name.camelize
  end

  def should_block?(object)
    object.annullable.annulled?
  end

  def validate_parent!(object)
    raise Exceptions::Unauthorized if should_block?(object)
  end
end
