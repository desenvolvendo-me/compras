class PeopleController < CrudController
  respond_to :js
  has_scope :term
  has_scope :by_legal_people, type: :boolean
  has_scope :by_physical_people, type: :boolean

  before_filter :check_person_type, only: [:index, :new, :edit, :filter]

  def index
    super
  end

  def create
    create! do |success, failure|
      if resource.personable_type == PersonableType::INDIVIDUAL
        success.html { redirect_to physical_peoples_path }
        @person_type = PersonableType::INDIVIDUAL
      else
        success.html { redirect_to legal_peoples_path }
        @person_type = PersonableType::COMPANY
      end
      failure.html { render "new" }
    end
  end

  def update
    update! do |success, failure|
      if resource.personable_type == PersonableType::INDIVIDUAL
        success.html { redirect_to physical_peoples_path }
        @person_type = PersonableType::INDIVIDUAL
      else
        success.html { redirect_to legal_peoples_path }
        @person_type = PersonableType::COMPANY
      end
      failure.html { render "edit" }
    end
  end

  def update_resource(object, attributes)
    object.personable.main_cnae_id = params[:person][:personable_attributes][:main_cnae_id] if object.company?
    super
  end

  def new
    person_type = Individual.new if params[:people]
    person_type = Company.new if params[:company]
    object = build_resource
    object.personable = person_type

    super
  end

  def check_person_type
    if params[:filter] && params[:filter][:personable_type] == PersonableType::INDIVIDUAL || params[:by_physical_people] || params[:people]
      @person_type = PersonableType::INDIVIDUAL
    end
    if params[:filter] && params[:filter][:personable_type] == PersonableType::COMPANY || params[:by_legal_people] || params[:company]
      @person_type = PersonableType::COMPANY
    end
  end
end
