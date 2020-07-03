class PeopleController < CrudController
  respond_to :js
  has_scope :term
  has_scope :by_legal_people, type: :boolean
  has_scope :by_physical_people, type: :boolean

  before_filter :check_person_type, only: [:index, :new, :edit, :filter]

  def index
    super
  end

  def new
    person_type = Individual.new if params[:by_physical_people]
    person_type = Company.new if params[:by_legal_people]
    object = build_resource
    object.personable = person_type

    super
  end

  def check_person_type
    if params[:filter] && params[:filter][:personable_type] == PersonableType::INDIVIDUAL || params[:by_physical_people] || params[:people]
      @person_type = PersonableType::INDIVIDUAL
    end
    if params[:filter] && params[:filter][:personable_type] == PersonableType::COMPANY ||  params[:by_legal_people] || params[:company]
    @person_type = PersonableType::COMPANY
    end
  end

end
