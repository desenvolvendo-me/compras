PurchaseProcessCreditorProposal.blueprint(:proposta_arame_farpado) do
  creditor           { Creditor.make!(:sobrinho_sa) }
  item               { PurchaseProcessItem.make!(:item_arame_farpado) }
  licitation_process { LicitationProcess.make!(:pregao_presencial) }
  brand              { 'Acme' }
  unit_price         { 4.99 }
end

PurchaseProcessCreditorProposal.blueprint(:proposta_arame) do
  creditor           { Creditor.make!(:sobrinho_sa) }
  item               { PurchaseProcessItem.make!(:item_arame) }
  licitation_process { LicitationProcess.make!(:pregao_presencial) }
  brand              { 'Acme' }
  unit_price         { 2.99 }
end

PurchaseProcessCreditorProposal.blueprint(:proposta_global_nohup) do
  creditor           { Creditor.make!(:nohup) }
  licitation_process { LicitationProcess.make!(:valor_maximo_ultrapassado) }
  unit_price         { 100.00 }
end

PurchaseProcessCreditorProposal.blueprint(:proposta_global_ibm) do
  creditor           { Creditor.make!(:ibm) }
  licitation_process { LicitationProcess.make!(:valor_maximo_ultrapassado) }
  unit_price         { 99.00 }
end
