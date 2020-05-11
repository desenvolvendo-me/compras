class PeopleController < CrudController
  respond_to :js
  has_scope :term

  def new
    object = build_resource
    object.personable = Individual.new

    super
  end
end
