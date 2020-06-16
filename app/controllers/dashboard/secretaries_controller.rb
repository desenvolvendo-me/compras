class Dashboard::SecretariesController < CrudController
  def index
    @contracts = Contract.by_days_finish(30)
    @contracts_periods = Contract.count_contracts_finishing
  end

  private

  def collection
   []
  end
end
