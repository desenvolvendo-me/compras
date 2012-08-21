LicitationProcessBidderProposal.blueprint(:proposta_licitante_1) do
  administrative_process_budget_allocation_item { AdministrativeProcessBudgetAllocationItem.make!(:item) }
  unit_price { 10.0 }
  brand { 'brand' }
  situation { SituationOfProposal::UNDEFINED }
end

LicitationProcessBidderProposal.blueprint(:proposta_2_licitante_1) do
  unit_price { 20.0 }
  situation { SituationOfProposal::UNDEFINED }
end

LicitationProcessBidderProposal.blueprint(:proposta_licitante_2) do
  administrative_process_budget_allocation_item { AdministrativeProcessBudgetAllocationItem.make!(:item) }
  unit_price { 9.0 }
  brand { 'brand' }
  situation { SituationOfProposal::UNDEFINED }
end

LicitationProcessBidderProposal.blueprint(:proposta_2_licitante_2) do
  unit_price { 9.0 }
  situation { SituationOfProposal::UNDEFINED }
end
