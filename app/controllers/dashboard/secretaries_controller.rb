class Dashboard::SecretariesController < CrudController
  has_scope :between_days_finish, using: %i[started_at ended_at], :type => :hash
  has_scope :by_days_finish, allow_blank: true

  def index
    @contracts = Contract.by_days_finish(30).page(params[:page]).per(5)

    @contracts_periods = Contract.count_contracts_finishing
  end

  def contracts
    @contracts = apply_scopes(Contract).page(params[:page]).per(5)
  end

  private

  def collection
   []
  end
end
