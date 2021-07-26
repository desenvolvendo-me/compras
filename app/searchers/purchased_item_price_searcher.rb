class PurchasedItemPriceSearcher
  include Quaestio

  repository LicitationProcessRatificationItem

  def licitation_process_id(licitation_process_id)
    joins { licitation_process_ratification.licitation_process }.
    where { licitation_process_ratification.licitation_process_id.eq(licitation_process_id) }
  end

  def material_id(id)
    joins { purchase_process_item.outer }.
    where { purchase_process_item.material_id.eq(id) }
  end

  def creditor_id(id)
    joins { licitation_process_ratification }.
    where { licitation_process_ratification.creditor_id.eq(id) }
  end

  def type_of_purchase(purchase)
    joins { licitation_process_ratification.licitation_process }.
    where { licitation_process_ratification.licitation_process.type_of_purchase.eq purchase }
  end

  def modality(modality_param)
    joins { licitation_process_ratification.licitation_process }.
    where { licitation_process_ratification.licitation_process.modality.eq modality_param }
  end

  def between_dates(dates_range)
    joins { licitation_process_ratification }.
    where { licitation_process_ratification.adjudication_date.in dates_range }
  end

  def ignore_items_not_adjudicated(ignore)
  end

  def grouping(group)
    case group
    when PurchasedItemPriceReportGrouping::CREDITOR
      joins { licitation_process_ratification.creditor }
    when PurchasedItemPriceReportGrouping::LICITATION
      joins { licitation_process_ratification.licitation_process }
    when PurchasedItemPriceReportGrouping::MATERIAL
      joins { purchase_process_item.material }
    end
  end
end
