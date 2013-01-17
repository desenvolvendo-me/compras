class PurchaseSolicitationBudgetAllocationItemStatusChanger
  # Change the status of purchase solicitation budget allocation item.
  #
  #   The new purchase solicitation
  #
  #   options - a hash that contains the new and old purchase solicitation ids [:new_ids, :old_ids]
  #
  # Examples:
  #
  #   PurchaseSolicitationBudgetAllocationItemStatusChanger.new(:new_item_ids => new_item_ids).change
  #   PurchaseSolicitationBudgetAllocationItemStatusChanger.new(:new_item_ids => new_item_ids, :old_items_ids => old_items_ids).change
  #   PurchaseSolicitationBudgetAllocationItemStatusChanger.new(:old_items_ids => old_items_ids).change
  def initialize(options = {})
    @new_item_ids = options.fetch(:new_item_ids, [])
    @old_item_ids = options.fetch(:old_item_ids, [])
    @new_purchase_solicitation = options[:new_purchase_solicitation]
    @old_purchase_solicitation = options[:old_purchase_solicitation]
    @purchase_solicitation_item_group_id = options[:purchase_solicitation_item_group_id]
    @new_purchase_solicitation_item_group = options[:new_purchase_solicitation_item_group]
    @old_purchase_solicitation_item_group = options[:old_purchase_solicitation_item_group]
    @direct_purchase = options[:direct_purchase]
    @administrative_process = options[:administrative_process]
    @item_repository = options[:item_repository] || PurchaseSolicitationBudgetAllocationItem
  end

  def change
    group_items_by_ids
    pending_items_by_ids

    pending_items_by_fulfiller(direct_purchase)
    pending_items_by_fulfiller(administrative_process)

    if new_purchase_solicitation
      if attend_items?(new_purchase_solicitation)
        attend_items_by_direct_purchase
        attend_items_by_administrative_process
      else
        partially_fulfilled_items_by_direct_purchase
        partially_fulfilled_items_by_administrative_process
      end
    end

    if new_purchase_solicitation_item_group
      if attend_items?(new_purchase_solicitation_item_group)
        item_repository.by_item_group(new_purchase_solicitation_item_group).attend!
      else
        item_repository.by_item_group(new_purchase_solicitation_item_group).partially_fulfilled!
      end
    end

    item_repository.by_item_group(old_purchase_solicitation_item_group).pending! if old_purchase_solicitation_item_group
  end

  private

  attr_reader :new_item_ids, :old_item_ids, :new_purchase_solicitation,
              :old_purchase_solicitation, :purchase_solicitation_item_group_id,
              :new_purchase_solicitation_item_group, :old_purchase_solicitation_item_group,
              :direct_purchase, :administrative_process, :item_repository

  def group_items_by_ids
    return unless new_item_ids.any?

    item_repository.group_by_ids!(new_item_ids, purchase_solicitation_item_group_id)
  end

  def pending_items_by_ids
    return unless old_item_ids.any?

    item_repository.pending_by_ids!(removed_item_ids)
  end

  def removed_item_ids
    old_item_ids - new_item_ids
  end

  def attend_items?(object)
    return unless object

    object.direct_purchase_authorized?
  end

  def attend_items_by_direct_purchase
    return unless new_purchase_solicitation.direct_purchase

    new_purchase_solicitation.direct_purchase.attend_purchase_solicitation_items
  end

  def attend_items_by_administrative_process
    return unless new_purchase_solicitation.administrative_process

    new_purchase_solicitation.administrative_process.attend_purchase_solicitation_items
  end

  def pending_items_by_fulfiller(object)
    return unless object && old_purchase_solicitation

    item_repository.by_fulfiller(object.id, object.class.name).pending!
  end

  def partially_fulfilled_items_by_direct_purchase
    return unless direct_purchase

    direct_purchase.partially_fulfilled_purchase_solicitation_items
  end

  def partially_fulfilled_items_by_administrative_process
    return unless administrative_process

    administrative_process.partially_fulfilled_purchase_solicitation_items
  end
end
