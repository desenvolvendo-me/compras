# encoding: utf-8
AdministrativeProcessBudgetAllocationItem.blueprint(:item) do
  material { Material.make!(:antivirus) }
  lot { 2050 }
  quantity { 2 }
  unit_price { 10.0 }
  additional_information { "produto antivirus avast" }
end

AdministrativeProcessBudgetAllocationItem.blueprint(:item_arame) do
  material { Material.make!(:arame_comum) }
  lot { 2050 }
  quantity { 1 }
  unit_price { 10.0 }
end

AdministrativeProcessBudgetAllocationItem.blueprint(:item_arame_farpado) do
  material { Material.make!(:arame_farpado) }
  lot { 2050 }
  quantity { 2 }
  unit_price { 30.0 }
  additional_information { "produto arame farpado" }
end

AdministrativeProcessBudgetAllocationItem.blueprint(:item_with_proposals) do
  material { Material.make!(:antivirus) }
  quantity { 2 }
  lot { 2050 }
  unit_price { 10.0 }
  bidder_proposals { [
    BidderProposal.make!(:proposta_licitante_1, :administrative_process_budget_allocation_item => object),
    BidderProposal.make!(:proposta_licitante_7, :administrative_process_budget_allocation_item => object),
    BidderProposal.make!(:proposta_licitante_2, :administrative_process_budget_allocation_item => object)
  ] }
  additional_information { "produto antivirus avg" }
end
