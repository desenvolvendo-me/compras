class PledgeCategoriesController < CrudController
  def create
    object = build_resource
    object.source = Source::MANUAL

    super
  end
end
