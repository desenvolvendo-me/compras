class SupplyOrdersController < CrudController
  has_scope :by_purchasing_unit

  def new
    if params[:supply_order].present?
      object = build_resource
      object.licitation_process_id = params[:supply_order][:licitation_process_id]
      object.contract_id = params[:supply_order][:contract_id]
      object.purchase_solicitation_id = params[:supply_order][:purchase_solicitation_id]
      params[:supply_order][:item_ids]&.each_pair do |index, item|
        object.items.new(material_id: item)
      end
    else
      super
    end
  end
end