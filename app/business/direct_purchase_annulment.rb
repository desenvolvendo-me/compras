class DirectPurchaseAnnulment
  attr_accessor :direct_purchase, :item_group_annulment, :resource_annul,
                :context, :email_sender

  delegate :purchase_solicitation,
           :supply_authorization,
           :to => :direct_purchase

  def initialize(options = {})
    self.direct_purchase = options.fetch(:direct_purchase)
    self.resource_annul  = options.fetch(:resource_annul)
    self.context         = options.fetch(:context)

    self.email_sender         = options.fetch(:email_sender) { SupplyAuthorizationEmailSender }
  end

  def annul
    change_purchase_solicitation_items

    liberate_purchase_solicitation

    send_supply_authorization_annulment_by_email
  end

  private

  def send_supply_authorization_annulment_by_email
    email_sender.new(supply_authorization, context).deliver
  end

  def change_purchase_solicitation_items
    return unless purchase_solicitation.present?

    purchase_solicitation.clear_items_fulfiller_and_status
  end

  def liberate_purchase_solicitation
    return unless supply_authorization.present? && purchase_solicitation.present?

    purchase_solicitation.liberate!
  end
end
