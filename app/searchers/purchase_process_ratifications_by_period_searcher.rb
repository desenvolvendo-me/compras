class PurchaseProcessRatificationsByPeriodSearcher
  include Quaestio
  repository LicitationProcessRatification

  def creditor_id(creditor_id)
    where { |query| query.creditor_id.eq creditor_id }
  end

  def object_type(object_type)
    joins { licitation_process }.
    where { |query| query.licitation_process.object_type.eq object_type }
  end

  def type_of_purchase(type_of_purchase)
    joins { licitation_process }.
    where { |query| query.licitation_process.type_of_purchase.eq type_of_purchase}
  end

  def modality(modality)
    joins { licitation_process }.
    where { |query| query.licitation_process.modality.eq modality }
  end

  def type_of_removal(type_of_removal)
    joins { licitation_process }.
    where { |query| query.licitation_process.type_of_removal.eq type_of_removal }
  end

  def between_dates(dates_range)
    where { ratification_date.in dates_range }
  end
end
