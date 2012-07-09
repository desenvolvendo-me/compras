class OccurrenceContractualHistoricsController < CrudController
  def new
    object = build_resource
    object.contract = Contract.find(params[:contract_id])

    super
  end

  def create
    create!{ occurrence_contractual_historics_path(:contract_id => resource.contract_id) }
  end

  def update
    update!{ occurrence_contractual_historics_path(:contract_id => resource.contract_id) }
  end

  def destroy
    destroy! { occurrence_contractual_historics_path(:contract_id => resource.contract_id) }
  end

  def begin_of_association_chain
    if params[:contract_id]
      @parent = Contract.find(params[:contract_id])
      return @parent
    end
  end
end
