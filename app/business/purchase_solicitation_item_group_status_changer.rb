class PurchaseSolicitationItemGroupStatusChanger
  def initialize(item_group, purchase_solicitation_status_changer = PurchaseSolicitationStatusChanger)
    @item_group = item_group
    @purchase_solicitation_status_changer = purchase_solicitation_status_changer
  end

  def self.change(*params)
    new(*params).change!
  end

  def change!
    return unless item_group

    item_group.fulfill!

    item_group.purchase_solicitations.each do |purchase_solicitation|
      purchase_solicitation_status_changer.change(purchase_solicitation)
    end
  end

  private

  attr_reader :item_group, :purchase_solicitation_status_changer
end
