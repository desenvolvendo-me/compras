class PurchaseSolicitationSearcher
  include Quaestio

  repository PurchaseSolicitation

  def budget_structure_id(id)
    where { budget_structure_id.eq(id) }
  end

  def kind(selected_kind)
    where { kind.eq(selected_kind) }
  end

  def status(selected_status)
    where { service_status.eq(selected_status) }
  end

  def material_id(id)
    joins { items }.
    where { material_id.eq(id) }
  end

  def between_dates(dates_range)
    where { request_date.in dates_range }
  end
end
