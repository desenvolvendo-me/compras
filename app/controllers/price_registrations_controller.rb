class PriceRegistrationsController < CrudController

  protected

  def default_filters
    { :year => lambda { Date.current.year } }
  end

  def interpolation_options
    { :resource_name => "#{resource_class.model_name.human} #{resource.number}/#{resource.year}" }
  end
end
