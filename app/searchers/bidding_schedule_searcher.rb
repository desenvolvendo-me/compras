class BiddingScheduleSearcher
  include Quaestio
  repository LicitationProcess

  def licitation_commission_id(licitation_commission_id)
    joins { judgment_commission_advice }.
    where {
      judgment_commission_advice.licitation_commission_id.eq licitation_commission_id
    }
  end

  def object_type(object_type)
    where { |query| query.object_type.eq object_type }
  end

  def modality(modality)
    where { |query| query.modality.eq modality }
  end

  def between_dates(dates_range)
    where { proposal_envelope_opening_date.in(dates_range) & type_of_purchase.eq(PurchaseProcessTypeOfPurchase::LICITATION) }.
    order { id }
  end
end
