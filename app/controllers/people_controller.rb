class PeopleController < CrudController
  respond_to :js

  def new
    object = build_resource
    object.personable = Individual.new

    super
  end
end
