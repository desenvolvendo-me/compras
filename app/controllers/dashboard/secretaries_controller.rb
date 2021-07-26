class Dashboard::SecretariesController < CrudController
  has_scope :between_days_finish, using: %i[started_at ended_at], :type => :hash
  has_scope :by_days_finish, allow_blank: true


  def index
    @contracts = Contract.between_days_finish(0,30).page(params[:page]).per(20)
    @contracts_periods = Contract.count_contracts_finishing
    @approval_requests = SupplyRequest.to_secretary_approv(current_user.authenticable.id).page(params[:page_approval]).per(5)
    @linked_contracts = LinkedContract.by_days_finish.page(params[:page]).per(2)
    @contract_additives = ContractAdditive.between_days_finish(Date.today,Date.today+30).page(params[:page]).per(2)
  end

  def contracts
    @contracts = apply_scopes(Contract).page(params[:page]).per(20)
  end
  
  def linked_contracts
    @linked_contracts = apply_scopes(LinkedContract).page(params[:page]).per(2)
  end
  
  def approval_requests
    @approval_requests = SupplyRequest.to_secretary_approv(current_user.authenticable.id).page(params[:page_approval]).per(5)
  end

  def contract_additives
    @contract_additives = apply_scopes(ContractAdditive).page(params[:page_contract_additive]).per(2)
  end

  private

  def collection
   []
  end

end
