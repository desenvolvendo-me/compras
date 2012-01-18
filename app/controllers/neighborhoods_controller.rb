class NeighborhoodsController < CrudController
  has_scope :street_id

  def new
    object = build_resource
    object.city_id = Setting.fetch('default_city')

    super
  end
end
