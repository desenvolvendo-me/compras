# encoding: utf-8
AdministrativeProcessBudgetAllocationItem.blueprint(:item) do
  material { Material.make!(:antivirus) }
  quantity { 2 }
  unit_price { 10.0 }
end

AdministrativeProcessBudgetAllocationItem.blueprint(:item_arame) do
  material { Material.make!(:arame_comum) }
  quantity { 1 }
  unit_price { 10.0 }
end

AdministrativeProcessBudgetAllocationItem.blueprint(:item_arame_farpado) do
  material { Material.make!(:arame_farpado) }
  quantity { 2 }
  unit_price { 30.0 }
end

AdministrativeProcessBudgetAllocationItem.blueprint(:item_with_proposals) do
  material { Material.make!(:antivirus) }
  quantity { 2 }
  unit_price { 10.0 }
  bidder_proposals { [
    BidderProposal.make!(:proposta_licitante_1, :administrative_process_budget_allocation_item => object),
    BidderProposal.make!(:proposta_licitante_7, :administrative_process_budget_allocation_item => object),
    BidderProposal.make!(:proposta_licitante_2, :administrative_process_budget_allocation_item => object)
  ] }
end
