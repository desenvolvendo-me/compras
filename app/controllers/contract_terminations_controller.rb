class ContractTerminationsController < CrudController
  def new
    object = build_resource
    object.year = Date.current.year
    object.number = object.next_number
    object.contract = Contract.find(params[:contract_id])

    super
  end

  def create
    create!{ contract_terminations_path(:contract_id => resource.contract_id) }
  end

  def update
    update!{ contract_terminations_path(:contract_id => resource.contract_id) }
  end

  def begin_of_association_chain
    if params[:licitation_process_id]
      @parent = LicitationProcess.find(params[:licitation_process_id])
      return @parent
    end

    super
  end

  protected

  def create_resource(object)
    object.year = Date.current.year

    super
  end
end
