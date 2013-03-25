class PurchaseSolicitationStatusChanger
  def initialize(purchase_solicitation, purchase_solicitation_repository = PurchaseSolicitation)
    @purchase_solicitation_repository = purchase_solicitation_repository
    @purchase_solicitation = find_purchase_solicitation(purchase_solicitation)
  end

  def self.change(*params)
    new(*params).change!
  end

  def change!
    return unless purchase_solicitation

    attend!
    partially_fulfilled!
    liberated_or_pending!
  end

  private

  attr_reader :purchase_solicitation, :purchase_solicitation_repository

  def attend!
    return unless all_items_attended?

    purchase_solicitation.attend!
  end

  def partially_fulfilled!
    return if all_items_attended?

    if items_partially_attended? || any_items_partially_fulfilled? || purchase_solicitation.direct_purchase.present?
      purchase_solicitation.partially_fulfilled!
    end
  end

  def liberated_or_pending!
    return unless all_items_pending?

    if purchase_solicitation.active_purchase_solicitation_liberation_liberated?
      purchase_solicitation.liberate!
    else
      purchase_solicitation.pending!
    end
  end

  def all_items_attended?
    purchase_solicitation.items.attended.any? && purchase_solicitation.items.attended.count == items_count
  end

  def items_partially_attended?
    purchase_solicitation.items.attended.any? && purchase_solicitation.items.attended.count != items_count
  end

  def any_items_partially_fulfilled?
    purchase_solicitation.items.partially_fulfilled.any?
  end

  def all_items_pending?
    purchase_solicitation.items.pending.any? && purchase_solicitation.items.pending.count == items_count
  end

  def items_count
    purchase_solicitation.items.count
  end

  def find_purchase_solicitation(purchase_solicitation)
    return unless purchase_solicitation

    purchase_solicitation_repository.find(purchase_solicitation.id)
  end
end
