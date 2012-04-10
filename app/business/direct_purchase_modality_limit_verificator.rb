class DirectPurchaseModalityLimitVerificator
  attr_accessor :direct_purchase, :limit_storage, :modality

  def initialize(direct_purchase, limit_storage = ModalityLimit)
    self.direct_purchase = direct_purchase
    self.limit_storage = limit_storage
  end

  def verify_limit_value!
    resultant_total_of_licitation_object <= current_limit
  end

  protected

  # future total when the direct purchase that is being created was saved
  def resultant_total_of_licitation_object
    current_total_of_licitation_object + value_to_be_added
  end

  # current modality limit value for the modality selected
  def current_limit
    if direct_purchase.material_or_service?
      limit_storage.current_limit_material_or_service_without_bidding
    elsif direct_purchase.engineering_works?
      limit_storage.current_limit_engineering_works_without_bidding
    end
  end

  # sum of all item values of all direct purchase items that belongs to selected
  # licitation object
  def current_total_of_licitation_object
    if direct_purchase.material_or_service?
      direct_purchase.licitation_object_purchase_licitation_exemption
    elsif direct_purchase.engineering_works?
      direct_purchase.licitation_object_build_licitation_exemption
    end
  end

  # total items value for direct purchase that is being created
  def value_to_be_added
    direct_purchase.total_allocations_items_value
  end
end
