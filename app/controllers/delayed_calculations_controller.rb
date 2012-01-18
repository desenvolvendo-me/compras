class DelayedCalculationsController < CrudController
  protected

  def create_resource(object)
    object.user_id = current_user.id

    if super
      DelayedCalculationCaller.new(object).call
    end
  end
end
