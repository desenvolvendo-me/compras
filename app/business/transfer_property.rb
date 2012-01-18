class TransferProperty
  attr_accessor :lower_payment_object

  def initialize(lower_payment_object)
    self.lower_payment_object = lower_payment_object
  end

  def transfer!
    change_the_owner! and change_the_status! if any?
  end

  private

  def property
    lower_payment_object.fact_generatable
  end

  def any?
    search_property_transfers.any?
  end

  def property_transfer
    search_property_transfers.first
  end

  def change_the_owner!
    property.update_attributes!(:owner_id => property_transfer.buyer_id)
  end

  def change_the_status!
    property_transfer.update_attributes!(:status => StatusOfTransfer::TRANSFERED)
  end

  def search_property_transfers
    property.property_transfers.where(:status => StatusOfTransfer::OPEN)
  end
end
