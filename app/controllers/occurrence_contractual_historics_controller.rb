class OccurrenceContractualHistoricsController < CrudController
  def index
    @parent = Contract.find(params[:contract_id])

    super
  end

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
    destroy! do |success, failure|
      failure.html do
        redirect_to edit_resource_path
      end

      success.html do
        redirect_to occurrence_contractual_historics_path(:contract_id => resource.contract_id)
      end
    end
  end
end
