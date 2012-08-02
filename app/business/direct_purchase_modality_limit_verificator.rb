class DirectPurchaseModalityLimitVerificator
  attr_accessor :direct_purchase, :limit_repository, :modality

  def initialize(direct_purchase, limit_repository = ModalityLimit)
    self.direct_purchase = direct_purchase
    self.limit_repository = limit_repository
  end

  def value_less_than_available_limit?
    total_items_value <= current_limit
  end

  protected

  # current modality limit value for the modality selected
  def current_limit
    if direct_purchase.material_or_service?
      limit_repository.current_limit_material_or_service_without_bidding
    elsif direct_purchase.engineering_works?
      limit_repository.current_limit_engineering_works_without_bidding
    end
  end

  # total items value for direct purchase that is being created
  def total_items_value
    direct_purchase.total_allocations_items_value
  end
end
