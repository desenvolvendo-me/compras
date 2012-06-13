class LicitationProcessLotsController < CrudController
  belongs_to :licitation_process

  before_filter :updatable?, :only => [:new, :create, :update, :destroy]

  protected

  def updatable?
    return if parent.updatable?

    raise Exceptions::Unauthorized
  end
end
