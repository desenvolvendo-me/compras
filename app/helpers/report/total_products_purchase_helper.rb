module Report::TotalProductsPurchaseHelper

  def self.get_items(creditor, material)
    items = creditor.licitation_process_ratification_items.joins(:purchase_process_item)
    items = items.where("compras_purchase_process_items.material_id = #{material}") if material.present?
    items
  end

end