class PurchaseSolicitationSearcher
  include Quaestio

  repository PurchaseSolicitationItem

  def kind(selected_kind)
    joins { purchase_solicitation }.
    where { purchase_solicitation.kind.eq(selected_kind) }
  end

  def status(selected_status)
    joins { purchase_solicitation }.
    where { purchase_solicitation.service_status.eq(selected_status) }
  end

  def material_id(id)
    where { material_id.eq(id) }
  end

  def between_dates(dates_range)
    joins { purchase_solicitation }.
    where { purchase_solicitation.request_date.in dates_range }.
    order { 'user_id, material_id' }
  end

  def user_id(id)
    joins{ purchase_solicitation }.where{ purchase_solicitation.user_id.eq(id) }
  end
end
