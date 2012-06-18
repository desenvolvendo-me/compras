class PeopleController < CrudController
  has_scope :except_special_entry

  respond_to :js

  def new
    object = build_resource
    object.personable = Individual.new

    super
  end
end
