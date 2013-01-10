class PurchaseSolicitationStatusChanger
  def initialize(purchase_solicitation)
    @purchase_solicitation = purchase_solicitation
  end

  def self.change(*params)
    new(*params).change!
  end

  def change!
    return unless purchase_solicitation

    attend!
    partially_fulfilled!
  end

  private

  attr_reader :purchase_solicitation

  def attend!
    return unless all_items_attended?

    purchase_solicitation.attend!
  end

  def partially_fulfilled!
    return unless items_partially_attended?

    purchase_solicitation.partially_fulfilled!
  end

  def all_items_attended?
    purchase_solicitation.items.attended.any? && purchase_solicitation.items.attended.count == items_count
  end

  def items_partially_attended?
    purchase_solicitation.items.attended.any? && purchase_solicitation.items.attended.count != items_count
  end

  def items_count
    purchase_solicitation.items.count
  end
end
