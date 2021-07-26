class ReserveFundRequestsController < CrudController
  defaults resource_class: LicitationProcess

  def reserve_funds_grid
    render partial: 'grid', collection: ReserveFund.by_purchase_process_id(resource.id),
      as: :reserve_fund
  end
end
