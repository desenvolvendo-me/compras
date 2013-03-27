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
    purchase_solicitation.attend!
  end

  def partially_fulfilled!
    if purchase_solicitation.direct_purchase.present?
      purchase_solicitation.partially_fulfilled!
    end
  end

  def liberated_or_pending!
    if purchase_solicitation.active_purchase_solicitation_liberation_liberated?
      purchase_solicitation.liberate!
    else
      purchase_solicitation.pending!
    end
  end

  def find_purchase_solicitation(purchase_solicitation)
    return unless purchase_solicitation

    purchase_solicitation_repository.find(purchase_solicitation.id)
  end
end
