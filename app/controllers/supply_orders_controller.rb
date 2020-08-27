class SupplyOrdersController < CrudController
  has_scope :by_purchasing_unit

  def new
    object = build_resource
    object.year = Time.now.year

    if params[:supply_order].present?
      object.licitation_process_id = params[:supply_order][:licitation_process_id]
      object.contract_id = params[:supply_order][:contract_id]
      object.purchase_solicitation_id = params[:supply_order][:purchase_solicitation_id]
      object.supply_requests.new(supply_request_id: params[:supply_order][:supply_request_id])
      params[:supply_order][:item]&.each_pair do |index, item|
        object.items.new(material_id: item[:id], quantity: item[:quantity])
      end
    else
      super
    end
  end

  def update
    update! { edit_supply_order_path }
  end
end