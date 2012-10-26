class AdministrativeProcessAnnulment
  attr_accessor :administrative_process, :context, :item_group_annulment_creator

  delegate :purchase_solicitation_item_group, :to => :administrative_process
  delegate :current_user, :to => :context

  def initialize(administrative_process, context, options = {})
    self.administrative_process = administrative_process
    self.context = context
    self.item_group_annulment_creator = options.fetch(:item_group_annulment_creator) { PurchaseSolicitationItemGroupAnnulmentCreator }
  end

  def annul
    administrative_process.update_status(AdministrativeProcessStatus::ANNULLED)

    annul_item_group
  end

  private

  def annul_item_group
    return unless purchase_solicitation_item_group.present?

    item_group_annul = item_group_annulment_creator.new(purchase_solicitation_item_group)

    item_group_annul.create_annulment(
      current_user.authenticable,
      Date.current,
      annulment_message
    )
  end

  def annulment_message
    I18n.t 'other.compras.messages.annulled_through_administrative_process', :administrative_process => administrative_process
  end
end
