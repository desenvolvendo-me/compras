class DirectPurchaseAnnulment
  attr_accessor :direct_purchase, :item_group_annulment, :resource_annul,
                :context, :email_sender

  delegate :purchase_solicitation_item_group, :purchase_solicitation,
           :supply_authorization,
           :to => :direct_purchase

  def initialize(options = {})
    self.direct_purchase = options.fetch(:direct_purchase)
    self.resource_annul  = options.fetch(:resource_annul)
    self.context         = options.fetch(:context)

    self.item_group_annulment = options.fetch(:item_group_annulment) { PurchaseSolicitationItemGroupAnnulmentCreator }
    self.email_sender         = options.fetch(:email_sender) { SupplyAuthorizationEmailSender }
  end

  def annul
    annul_purchase_solicitation_item_group

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

  def annul_purchase_solicitation_item_group
    return unless purchase_solicitation_item_group.present?

    item_group_annulment.new(purchase_solicitation_item_group).
                         create_annulment(
                           resource_annul.employee,
                           resource_annul.date,
                           resource_annul.description
                         )
  end
end
