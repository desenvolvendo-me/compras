BidderProposal.blueprint(:proposta_licitante_1) do
  purchase_process_item { PurchaseProcessItem.make!(:item) }
  unit_price { 10.0 }
  brand { 'brand' }
  situation { SituationOfProposal::UNDEFINED }
end

BidderProposal.blueprint(:proposta_licitante_2) do
  purchase_process_item { PurchaseProcessItem.make!(:item) }
  unit_price { 9.0 }
  brand { 'brand' }
  situation { SituationOfProposal::UNDEFINED }
end

BidderProposal.blueprint(:proposta_licitante_3) do
  purchase_process_item { PurchaseProcessItem.make!(:item) }
  unit_price { 9.10 }
  brand { 'brand' }
  situation { SituationOfProposal::UNDEFINED }
end

BidderProposal.blueprint(:proposta_licitante_4) do
  purchase_process_item { PurchaseProcessItem.make!(:item) }
  unit_price { 9.0 }
  brand { 'brand' }
  situation { SituationOfProposal::UNDEFINED }
end

BidderProposal.blueprint(:proposta_licitante_5) do
  purchase_process_item { PurchaseProcessItem.make!(:item) }
  unit_price { 10.0 }
  brand { 'brand' }
  situation { SituationOfProposal::UNDEFINED }
end

BidderProposal.blueprint(:proposta_licitante_7) do
  purchase_process_item { PurchaseProcessItem.make!(:item) }
  unit_price { 11.0 }
  brand { 'brand' }
  situation { SituationOfProposal::UNDEFINED }
end
