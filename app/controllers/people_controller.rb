class PeopleController < CrudController
  respond_to :js
  has_scope :term
  has_scope :by_legal_people, type: :boolean
  has_scope :by_physical_people, type: :boolean

  def index
    super
  end

  def new
    object = build_resource
    object.personable = Individual.new

    super
  end
end
