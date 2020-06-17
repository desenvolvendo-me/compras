class Dashboard::SecretariesController < CrudController
  has_scope :between_days_finish, using: %i[started_at ended_at], :type => :hash
  has_scope :by_days_finish, allow_blank: true

  def index
    @contracts = Contract.by_days_finish(30).page(params[:page]).per(5)
    @contracts_periods = Contract.count_contracts_finishing
    employee = current_user.authenticable.id
    @approval_requests = SupplyRequest.joins{ supply_request_attendances.outer }.joins { department.secretary.secretary_settings }
                           .where{ supply_request_attendances.id.eq(nil) }.where { compras_secretary_settings.employee_id.eq(employee) }.page(params[:page_approval]).per(5)
  end

  def contracts
    @contracts = apply_scopes(Contract).page(params[:page]).per(5)
  end

  def approval_requests
    @approval_requests = SupplyRequest.joins{ supply_request_attendances.outer }.joins { department.secretary.secretary_settings }
                             .where{ supply_request_attendances.id.eq(nil) }.where { compras_secretary_settings.employee_id.eq(current_user.authenticable.id) }.page(params[:page_approval]).per(5)
  end

  private

  def collection
   []
  end
end
