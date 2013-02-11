class OccurrenceContractualHistoricsController < CrudController
  def new
    object = build_resource
    object.contract = Contract.find(parent_id)

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
    if parent_id
      @parent = Contract.find(parent_id)
    end
  end

  protected

  def parent_id
    params[:contract_id]
  end
end
