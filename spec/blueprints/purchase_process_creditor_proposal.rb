# encoding: utf-8
PurchaseProcessCreditorProposal.blueprint(:proposta_arame_farpado) do
  creditor   { Creditor.make!(:sobrinho_sa) }
  item       { PurchaseProcessItem.make!(:item_arame_farpado) }
  brand      { 'Acme' }
  unit_price { 4.99 }
end

PurchaseProcessCreditorProposal.blueprint(:proposta_arame) do
  creditor   { Creditor.make!(:sobrinho_sa) }
  item       { PurchaseProcessItem.make!(:item_arame) }
  brand      { 'Acme' }
  unit_price { 2.99 }
end
