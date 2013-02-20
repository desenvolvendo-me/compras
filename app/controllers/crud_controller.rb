class CrudController < ApplicationController
  before_filter :authorize_resource!

  inherit_resources

  respond_to :js, :json

  has_scope :filter, :type => :hash
  has_scope :page, :default => 1, :only => [:index, :modal], :unless => :disable_pagination?
  has_scope :per, :default => 10, :only => [:index, :modal], :unless => :disable_pagination?

  custom_actions :collection => [:filter, :modal], :member => :modal_info

  helper_method :main_controller_name

  def create
    create! { collection_path }
  end

  def update
    update! { collection_path }
  end

  def destroy
    destroy! do |success, failure|
      failure.html do
        # FIXME: I'm not sure about why flash is lost here but
        # if we don't keep, the failure message is not shown.
        flash.keep

        redirect_to edit_resource_path
      end
    end
  end

  def filter
    object = build_resource
    object.assign_attributes(params[:filter])

    render :layout => false
  end

  def modal
    build_resource

    render :layout => false
  end

  def modal_info
    show!
  end

  protected

  def smart_resource_path
    path = nil
    if respond_to? :show
      path = resource_path rescue nil
    end
    path ||= smart_collection_path
  end

  helper_method :smart_resource_path

  def smart_collection_path
    path = nil
    if respond_to? :index
      path ||= collection_path rescue nil
    end
    if respond_to? :parent
      path ||= parent_path rescue nil
    end
    path ||= root_path rescue nil
  end

  helper_method :smart_collection_path

  # Build resource using I18n::Alchemy
  def build_resource
    get_resource_ivar || set_resource_ivar(effectively_build_resource)
  end

  # Effectively build resource using I18n::Alchemy
  def effectively_build_resource
    end_of_association_chain.send(method_for_build).tap do |object|
      object.localized.assign_attributes(*resource_params)
    end
  end

  # Update resource using I18n::Alchemy
  def update_resource(object, attributes)
    object.localized.update_attributes(*attributes)
  end

  # Get collection using ordered scope
  def collection
    get_collection_ivar || set_collection_ivar(end_of_association_chain.ordered)
  end

  def disable_pagination?
    params[:page] == 'all'
  end

  def main_controller_name
    MainControllerGetter.new(controller_name).name
  end

  def authorize_resource!
    authorize! action_name, main_controller_name
  end
end
