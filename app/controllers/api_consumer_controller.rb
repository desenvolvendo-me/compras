class ApiConsumerController < CrudController
  before_filter :load_site

  def modal
    set_resource_ivar(resource_class)

    render :layout => false
  end

  protected

  def collection
    get_collection_ivar || set_collection_ivar(resource_class.fetch(params: fetch_params))
  end

  def effectively_build_resource
    end_of_association_chain.send(method_for_build).tap do |object|
      return object.class.new.localized(*resource_params).parse_attributes!
    end
  end

  def update_resource(object, attributes)
    object.localized.update_attributes(*attributes)
  end

  def fetch_params
    params
  end

  def load_site
    resource_class.site
  end
end
