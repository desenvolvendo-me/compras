class PurchaseSolicitationStatusChanger
  attr_accessor :purchase_solicitation

  def initialize(item_group)
    @item_group = item_group
  end

  def self.change(*params)
    new(*params).change!
  end

  def change!
    return unless item_group

    item_group.purchase_solicitations.each do |purchase_solicitation|
      @purchase_solicitation = purchase_solicitation

      attend!
      partially_fulfilled!
    end
  end

  private

  attr_reader :item_group

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
