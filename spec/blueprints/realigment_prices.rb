# encoding: utf-8
RealigmentPrice.blueprint(:realinhamento) do
  proposal { PurchaseProcessCreditorProposal.make!(:proposta_global_nohup) }
  item { PurchaseProcessItem.make!(:item) }
  price { 9.99 }
  brand { "Acme" }
  delivery_date { Date.current }
  quantity { 2 }
end
