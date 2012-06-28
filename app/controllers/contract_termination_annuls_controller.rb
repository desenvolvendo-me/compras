class ContractTerminationAnnulsController < CrudController
  defaults :resource_class => ResourceAnnul

  before_filter :block_contract_termination_not_allowed, :only => [:new, :create]

  def new
    object = build_resource
    object.date = Date.current
    object.employee = current_user.authenticable
    object.annullable = @contract_termination

    super
  end

  def create
    create!{ edit_contract_termination_path(resource.annullable) }
  end

  def update
    raise Exceptions::Unauthorized
  end

  protected

  def block_contract_termination_not_allowed
    contract_termination_id = params[:contract_termination_id] || params[:resource_annul][:annullable_id]
    @contract_termination = ContractTermination.find(contract_termination_id)

    raise Exceptions::Unauthorized if @contract_termination.annulled?
  end
end
