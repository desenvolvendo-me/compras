class CrudController < ApplicationController
  before_filter :authorize_resource!

  inherit_resources

  respond_to :js, :json

  has_scope :filter, :type => :hash
  has_scope :page, :default => 1, :only => [:index, :modal], :unless => :disable_pagination?
  has_scope :per_page, :default => 10, :only => [:index, :modal], :unless => :disable_pagination?

  custom_actions :collection => [:filter, :modal]

  def create
    create! { collection_path }
  end

  def update
    update! { collection_path }
  end

  def destroy
    destroy! do |success, failure|
      failure.html do
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

  protected

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
end
