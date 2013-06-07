class SupplyOrderQuantitiesController < CrudController
  defaults resource_class: SupplyOrder

  actions :edit, :update

  def edit
    LicitationProcessRatificationItem.by_licitation_process_and_creditor(resource.licitation_process, resource.creditor).each do |item|
      resource.items.build({licitation_process_ratification_item_id: item.id})
    end
  end

  def update
    update! do |success, failure|
      success.html { redirect_to edit_supply_order_path(resource) }
    end
  end
end
