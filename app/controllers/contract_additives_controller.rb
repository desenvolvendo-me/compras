class ContractAdditivesController < CrudController
  def index
    @parent = Contract.find(parent_id)
    @contract_additives = ContractAdditive.by_contract_id(parent_id)
  end

  def new
    object = build_resource
    object.contract = Contract.find(parent_id)

    super
  end

  def create
    create!{ contract_additives_path(:contract_id => resource.contract_id) }
  end

  def update
    update!{ contract_additives_path(:contract_id => resource.contract_id) }
  end

  def destroy
    destroy! { contract_additives_path(:contract_id => resource.contract_id) }
  end

  protected

  def parent_id
    params[:contract_id]
  end
end
