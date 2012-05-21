class LicitationProcessesController < CrudController
  actions :all, :except => [ :destroy, :index ]

  def new
    administrative_process = AdministrativeProcess.find(params[:administrative_process_id])

    object = build_resource
    object.year = Date.current.year
    object.process_date = Date.current
    object.administrative_process = administrative_process
    object.modality = administrative_process.modality

    super
  end

  def create
    create!{ edit_administrative_process_path(resource.administrative_process) }
  end

  def update
    update!{ edit_administrative_process_path(resource.administrative_process) }
  end

  protected

  def create_resource(object)
    BidderStatusChanger.new(object).change

    object.process = object.next_process
    object.licitation_number = object.next_licitation_number

    super
  end

  def update_resource(object, attributes)
    return unless object.can_update?
    object.localized.assign_attributes(*attributes)

    BidderStatusChanger.new(object).change

    object.save
  end
end
