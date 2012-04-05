class DirectPurchaseModalityLimitVerificator
  attr_accessor :direct_purchase, :limit_storage, :modality

  def initialize(direct_purchase, limit_storage=ModalityLimit)
    self.direct_purchase = direct_purchase
    self.limit_storage = limit_storage
  end

  def verify!
    resultant_total_of_licitation_object <= current_limit
  end

  protected

  # future total when the direct purchase that is being created was saved
  def resultant_total_of_licitation_object
    current_total_of_licitation_object + value_to_be_added
  end

  # current modality limit value for the modality selected
  def current_limit
    case direct_purchase.modality
    when DirectPurchaseModality::MATERIAL_OR_SERVICE
      limit_storage.current_modality_limit.without_bidding
    when DirectPurchaseModality::ENGINEERING_WORKS
      limit_storage.current_modality_limit.work_without_bidding
    end
  end

  # sum of all item values of all direct purchase items that belongs to selected
  # licitation object
  def current_total_of_licitation_object
    case direct_purchase.modality
    when DirectPurchaseModality::MATERIAL_OR_SERVICE
      direct_purchase.licitation_object.purchase_licitation_exemption
    when DirectPurchaseModality::ENGINEERING_WORKS
      direct_purchase.licitation_object.build_licitation_exemption
    end
  end

  # total items value for direct purchase that is being created
  def value_to_be_added
    direct_purchase.total_allocations_items_value
  end
end
