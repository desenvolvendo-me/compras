class ContractValidationsController < CrudController
  actions :all, :only => [:new, :create, :edit]

  before_filter :set_contract, :only => [:new, :create]

  def new
    object = build_resource
    object.responsible = current_user.authenticable
    object.date = Date.current
    object.contract = @parent

    super
  end

  def create
    create! do |success, failure|
      success.html { redirect_to(edit_contract_path(@parent.id)) }
    end
  end

  def begin_of_association_chain
    if params[:contract_id]
      @parent = Contract.find(params[:contract_id])
    end
  end

  private

  def set_contract
    @parent ||= Contract.find(params[:contract_id] ||
                                  params[:contract_validation][:contract_id])
  end
end
