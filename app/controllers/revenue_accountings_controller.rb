class RevenueAccountingsController < CrudController
  protected

  def create_resource(object)
    object.code = object.next_code

    super
  end
end
