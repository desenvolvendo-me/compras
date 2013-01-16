class PurchaseSolicitationItemGroupStatusChanger
  def initialize(item_group, purchase_solicitation_status_changer = PurchaseSolicitationStatusChanger, item_group_repository = PurchaseSolicitationItemGroup)
    @purchase_solicitation_status_changer = purchase_solicitation_status_changer
    @item_group_repository = item_group_repository
    @item_group = find_item_group(item_group)
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

  attr_reader :item_group, :purchase_solicitation_status_changer, :item_group_repository

  def find_item_group(item_group)
    return unless item_group

    item_group_repository.find(item_group.id)
  end
end
