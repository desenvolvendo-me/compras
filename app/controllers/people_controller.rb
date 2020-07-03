class PeopleController < CrudController
  respond_to :js
  has_scope :term
  has_scope :by_legal_people, type: :boolean
  has_scope :by_physical_people, type: :boolean

  def new
    person_type = Individual.new if params[:people] === 'true'
    person_type = Company.new if params[:company] === 'true'
    object = build_resource
    object.personable = person_type

    super
  end
end
