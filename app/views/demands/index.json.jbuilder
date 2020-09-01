json.array!(collection) do |obj|
  json.id                obj.id
  json.value             obj.to_s
  json.label             obj.to_s
  json.to_s             obj.to_s
  json.purchaseSolicitations obj.purchase_solicitations do |psba|
    json.id                psba.id
    json.value             psba.to_s
    json.label             psba.to_s
    json.code_and_year     psba.decorator.code_and_year
    json.department        psba.department.to_s
    json.user              psba.user.to_s
    json.total_items_value psba.total_items_value.to_f
    json.items psba.items do |item|
      json.id                           item.id
      json.material_id                  item.material_id
      json.material_description         item.material.to_s
      json.lot                          item.lot
      json.brand                        item.brand
      json.reference_unit               item.material.reference_unit.to_s
      json.quantity                     item.quantity.to_f
      json.unit_price                   item.unit_price.to_f
      # json.estimated_total_price        item.estimated_total_price.to_f
      # json.average_proposal_unit_price  item.average_proposal_item_price.to_f
      # json.average_proposal_total_price item.average_proposal_total_price.to_f
      # json.proposal_winner              item.proposal_creditor_winner.try(:to_s)
      # json.proposal_winner_id           item.proposal_creditor_winner.try(:id)
      # json.proposal_unit_price_winner   item.proposal_unit_price_winner.to_f
      # json.proposal_total_price_winner  item.proposal_total_price_winner.to_f
    end
  end
end
